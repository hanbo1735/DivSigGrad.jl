module DivSigGrad
export getDivSigGradMatrix,DivSigGradParam, getData, getSensMatVec, getSensTMatVec

using jInv.Mesh
using jInv.LinearSolvers
using jInv.Utils


export DivSigGradParam, getDivSigGradParam
import jInv.ForwardShare.ForwardProbType

"""
type DivSigGrad.DivSigGradParam <: ForwardProbType

defines one DivSigGrad problem

Fields:

	Mesh::AbstractMesh
	Sources::Union{SparseMatrixCSC,Array}
	Receivers::Union{SparseMatrixCSC,Array{SparseMatrixCSC}}
	Fields::Array{Float64}
	A::SparseMatrixCSC{Float64}
	Ainv::AbstractSolver
"""
type DivSigGradParam <: ForwardProbType
    Mesh::AbstractMesh
    Sources::Union{SparseMatrixCSC,Array,SparseVector}
    Receivers::Union{SparseMatrixCSC,Array{SparseMatrixCSC},SparseVector}
	Fields::Array{Float64}
	A::SparseMatrixCSC{Float64}
    Ainv::AbstractSolver
end

"""
function getDivSigGradParam
	
constructor for DivSigGradParam

Required Inputs

	Mesh::AbstractMesh
	Sources::Union{SparseMatrixCSC,Array}
	Receivers::Union{SparseMatrixCSC,Array{SparseMatrixCSC}}

Optional Inputs (initialized as empty by default)

	Fields::Array{Float64}
	A::SparseMatrixCSC{Float64}
	Ainv::AbstractSolver
	
"""
function getDivSigGradParam(Mesh::AbstractMesh, Sources::Union{SparseMatrixCSC,Array,SparseVector},
	                        Receivers::Union{SparseMatrixCSC,Array{SparseMatrixCSC},SparseVector};
							Fields::Array{Float64}=[0.0], A::SparseMatrixCSC{Float64}=spzeros(0,0),			 
							Ainv::AbstractSolver=getJuliaSolver())
	return DivSigGradParam(Mesh,Sources,Receivers,Fields,A,Ainv)
end

import jInv.ForwardShare.getNumberOfData
getNumberOfData(pFor::DivSigGradParam) = getNdata(pFor.Sources,pFor.Receivers)

getNdata(Sources,Receivers) = (size(Sources,2)*size(Receivers,2))
getNdata(Sources,Receivers::Array{SparseMatrixCSC}) =  (nd = 0; for k=1:length(Receivers); nd+= size(Receivers[k],2); end; return nd)

import jInv.ForwardShare.getSensMatSize
getSensMatSize(pFor::DivSigGradParam) = (getNumberOfData(pFor),pFor.Mesh.nc)


include("getDivSigGradMatrix.jl")
include("getData.jl")
include("getSensMatVec.jl")
include("getSensTMatVec.jl")


end
