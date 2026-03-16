local s,id,o=GetID()
function s.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_ALL&~ATTRIBUTE_WIND),4,2)
	c:EnableReviveLimit()
	
	--same race: cannot be material for same race
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
	e1:SetValue(s.fuslimit1)
	local g1=Effect.CreateEffect(c)
	g1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	g1:SetRange(LOCATION_MZONE)
	g1:SetTargetRange(0,LOCATION_MZONE)
	g1:SetCondition(s.con1)
	g1:SetLabelObject(e1)
	c:RegisterEffect(g1)
	
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	e2:SetValue(s.matlimit1)
	local g2=g1:Clone()
	g2:SetLabelObject(e2)
	c:RegisterEffect(g2)
	
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	e3:SetValue(s.matlimit1)
	local g3=g1:Clone()
	g3:SetLabelObject(e3)
	c:RegisterEffect(g3)
	
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
	e4:SetValue(s.matlimit1)
	local g4=g1:Clone()
	g4:SetLabelObject(e4)
	c:RegisterEffect(g4)

	--different race: cannot be material for different race
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
	e5:SetValue(s.fuslimit2)
	local g5=Effect.CreateEffect(c)
	g5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	g5:SetRange(LOCATION_MZONE)
	g5:SetTargetRange(0,LOCATION_MZONE)
	g5:SetCondition(s.con2)
	g5:SetLabelObject(e5)
	c:RegisterEffect(g5)
	
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	e6:SetValue(s.matlimit2)
	local g6=g5:Clone()
	g6:SetLabelObject(e6)
	c:RegisterEffect(g6)
	
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE)
	e7:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	e7:SetValue(s.matlimit2)
	local g7=g5:Clone()
	g7:SetLabelObject(e7)
	c:RegisterEffect(g7)
	
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE)
	e8:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
	e8:SetValue(s.matlimit2)
	local g8=g5:Clone()
	g8:SetLabelObject(e8)
	c:RegisterEffect(g8)
end
function s.mat_status(c)
	if not c:IsFaceup() then return 0 end
	local g=c:GetOverlayGroup()
	if #g~=2 or g:FilterCount(Card.IsType,nil,TYPE_MONSTER)~=2 then return 0 end
	local tc1=g:GetFirst()
	local tc2=g:GetNext()
	if tc1:GetRace()==tc2:GetRace() then
		return 1
	else
		return 2
	end
end
function s.con1(e)
	return s.mat_status(e:GetHandler())==1
end
function s.con2(e)
	return s.mat_status(e:GetHandler())==2
end
function s.fuslimit1(e,c,sumtype)
	if not c then return false end
	return sumtype==SUMMON_TYPE_FUSION and c:IsRace(e:GetHandler():GetRace())
end
function s.fuslimit2(e,c,sumtype)
	if not c then return false end
	return sumtype==SUMMON_TYPE_FUSION and not c:IsRace(e:GetHandler():GetRace())
end
function s.matlimit1(e,c)
	if not c then return false end
	return c:IsRace(e:GetHandler():GetRace())
end
function s.matlimit2(e,c)
	if not c then return false end
	return not c:IsRace(e:GetHandler():GetRace())
end