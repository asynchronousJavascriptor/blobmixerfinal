precision highp float;

uniform float uTime;
uniform float uPositionFrequency;
uniform float uTimeFrequency;
uniform float uStrength;

uniform float uWrappedPositionFrequency;
uniform float uWrappedTimeFrequency;
uniform float uWrappedStrength;

attribute vec3 tangent;

#include simplexNoise4d.glsl

float getBlob(vec3 position) {

    vec3 wrappedPosition = position;
    wrappedPosition += simplexNoise4d(vec4(position * uWrappedPositionFrequency, uTime * uWrappedTimeFrequency)) * uWrappedStrength;

    return simplexNoise4d(vec4(wrappedPosition * uPositionFrequency, uTime * uTimeFrequency)) * uStrength;
}

void main() {

    vec3 bitangent = cross(tangent.xyz, normal);

    float shift = 0.07;
    vec3 A = csm_Position + shift * tangent.xyz;
    vec3 B = csm_Position + shift * bitangent;

    float blob = getBlob(csm_Position);
    csm_Position += blob * normal;

    A += getBlob(A) * normal;
    B += getBlob(B) * normal;

    vec3 toA = normalize(A - csm_Position);
    vec3 toB = normalize(B - csm_Position);

    csm_Normal = -cross(toA, toB);
}