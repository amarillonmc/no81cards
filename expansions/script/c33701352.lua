--动物朋友 薮胞
function c33701352.initial_effect(c)
	c:SetUniqueOnField(1,1,33701352)
	--link summon
	aux.AddLinkProcedure(c,nil,2,4,c33701352.lcheck)
	c:EnableReviveLimit()
	--adjust
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetCode(EVENT_ADJUST)
	e2:SetRange(LOCATION_SZONE)
	e2:SetOperation(c33701352.adjustop)
	c:RegisterEffect(e2)
	--cannot summon,spsummon,flipsummon
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetTargetRange(1,1)
	e4:SetTarget(c33701352.sumlimit)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EFFECT_CANNOT_SUMMON)
	c:RegisterEffect(e5)
	local e6=e4:Clone()
	e6:SetCode(EFFECT_CANNOT_FLIP_SUMMON)
	c:RegisterEffect(e6)
	--cannot set
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_FIELD)
	e7:SetCode(EFFECT_CANNOT_MSET)
	e7:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e7:SetRange(LOCATION_MZONE)
	e7:SetTargetRange(1,1)
	e7:SetTarget(c33701352.setlimit)
	c:RegisterEffect(e7)
	local e8=e7:Clone()
	e8:SetCode(EFFECT_CANNOT_SSET)
	c:RegisterEffect(e8)
	local e9=e7:Clone()
	e9:SetCode(EFFECT_CANNOT_TURN_SET)
	c:RegisterEffect(e9)
end
function c33701352.setlimit(e,c)
	return Duel.GetMatchingGroupCount(Card.IsFacedown,c:GetControler(),LOCATION_ONFIELD,0,nil)>0
end
function c33701352.filter(g)
	local c1=g:GetFirst()
	local c2=g:GetNext()
	return c1:IsCode(c2:GetCode()) or c2:IsCode(c1:GetCode())
end
function c33701352.lcheck(g)
	if g:CheckSubGroup(c33701352.filter,2,2) then return false end
	if g:IsExists(Card.IsSetCard,1,nil,0x442) then 
		return true
	else
		return g:GetCount()==4
	end
end
function c33701352.rmfilter(c,rc)
	return c:IsFaceup() and (c:IsCode(rc:GetCode()) or rc:IsCode(c:GetCode()))
end
function c33701352.sumlimit(e,c,sump,sumtype,sumpos,targetp)
	if sumtype==SUMMON_TYPE_DUAL then return false end
	if sumpos and bit.band(sumpos,POS_FACEDOWN)>0 then 
		if  targetp then
			return 
				Duel.GetMatchingGroupCount(Card.IsFacedown,targetp,LOCATION_ONFIELD,0,nil)>0 
		else
			return 
				Duel.GetMatchingGroupCount(Card.IsFacedown,sump,LOCATION_ONFIELD,0,nil)>0 
		end
	end
	local tp=sump
	if targetp then tp=targetp end
	return Duel.IsExistingMatchingCard(c33701352.rmfilter,tp,LOCATION_MZONE,0,1,nil,c)
end
function c33701352.tgfilter(g)
	local c1=g:GetFirst()
	local c2=g:GetNext()
	return ((c1:IsCode(c2:GetCode()) or c2:IsCode(c1:GetCode())) and c1:IsFaceup()and c2:IsFaceup())
end
function c33701352.tgfilter1(g,sg)
	local g1=Group.__bxor(g,sg)
	return not g1:CheckSubGroup(c33701352.tgfilter,2,2) and g1:FilterCount(Card.IsFacedown,nil)<2
end
function c33701352.adjustop(e,tp,eg,ep,ev,re,r,rp)
	local phase=Duel.GetCurrentPhase()
	if (phase==PHASE_DAMAGE and not Duel.IsDamageCalculated()) or phase==PHASE_DAMAGE_CAL then return end
	local sg=Group.CreateGroup()
	for p=0,1 do
		local g=Duel.GetMatchingGroup(nil,p,LOCATION_ONFIELD,0,nil)
		local sg=Group.CreateGroup()
		if g:CheckSubGroup(c33701352.tgfilter,2,g:GetCount()) or g:FilterCount(Card.IsFacedown,nil)>1 then
			Duel.Hint(HINT_SELECTMSG,p,HINTMSG_TOGRAVE)
			local g=g:SelectSubGroup(p,c33701352.tgfilter1,true,1,g:GetCount(),nil,g)
			sg:Merge(dg)
		end
	end
	if sg:GetCount()>0 then
		Duel.SendtoGrave(sg,REASON_RULE)
		Duel.Readjust()
	end
end