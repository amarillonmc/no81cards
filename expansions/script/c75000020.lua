--神龙团结
local m=75000020
local cm=_G["c"..m]
function cm.initial_effect(c)
	aux.AddCodeList(c,75000001)
	c:SetUniqueOnField(1,0,75000020)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--recover
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(75000020,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetRange(LOCATION_SZONE) 
	e2:SetCondition(c75000020.spccon)
	e2:SetTarget(c75000020.spctg)
	e2:SetOperation(c75000020.spcop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
------
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_CANNOT_INACTIVATE)
	e4:SetRange(LOCATION_SZONE)
	e4:SetValue(c75000020.efilter)
	c:RegisterEffect(e4)
	
end
function c75000020.efilter(e,ct)
	local p=e:GetHandlerPlayer()
	local te,tp=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
	return p==tp and te:IsHasCategory(CATEGORY_FUSION_SUMMON)
end

function c75000020.SPcfilter(c,tp)
	return c:IsFaceup() and c:IsSummonPlayer(tp) and c:IsSetCard(0x3751)
end
function c75000020.spccon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c75000020.SPcfilter,1,nil,tp)
end
function c75000020.filter(c,att)
	return c:IsFaceup() and c:IsAttribute(att)
end
function c75000020.spfilter(c,e,tp)
	return aux.IsCodeListed(c,75000001) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and not Duel.IsExistingMatchingCard(c75000020.filter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,nil,c:GetAttribute())
end
function c75000020.spctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c75000020.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c75000020.spcop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c75000020.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
		if g:GetCount()>0 and Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)~=0 then
			local att=g:GetFirst():GetAttribute()
			local e0=Effect.CreateEffect(c)
			e0:SetType(EFFECT_TYPE_FIELD)
			e0:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
			e0:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e0:SetTargetRange(1,0)
			e0:SetTarget(c75000020.splimit)
			e0:SetLabel(att)
			e0:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e0,tp)
		end
	end
end
function c75000020.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return c:IsAttribute(e:GetLabel()) and se and se:GetHandler():IsCode(75000020)
end




