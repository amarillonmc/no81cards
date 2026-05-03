--劲弩模式
local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,16190326)
	c:SetUniqueOnField(1,0,id)   
	--发动    
    local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--衍生物
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetRange(LOCATION_SZONE)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCondition(s.spcon)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
end    
function s.spfilter(c,tp)
	return c:IsSummonPlayer(1-tp)
end
function s.cfilter(c)
	return c:IsCode(16190326) and c:IsFaceup()
end
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.spfilter,1,nil,tp) 
    	and not Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_ONFIELD,0,1,nil)
end    
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and
		Duel.IsPlayerCanSpecialSummonMonster(tp,16190326,0,TYPES_TOKEN_MONSTER,1500,1500,4,RACE_MACHINE,ATTRIBUTE_LIGHT) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0)
end
function s.synfilter(c,tuner)
	return c:IsType(TYPE_SYNCHRO) and c:IsSynchroSummonable(tuner)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_ONFIELD,0,1,nil) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
		or not Duel.IsPlayerCanSpecialSummonMonster(tp,16190326,0,TYPES_TOKEN_MONSTER,1500,1500,4,RACE_MACHINE,ATTRIBUTE_LIGHT) then return end
	local token=Duel.CreateToken(tp,16190326)
	if Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)~=0 then
    	Duel.AdjustAll()
		local g=Duel.GetMatchingGroup(s.synfilter,tp,LOCATION_EXTRA,0,nil,token)
        if g:GetCount()>0 and token:IsLocation(LOCATION_MZONE) and token:IsControler(tp) and token:IsFaceup()
			and Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sg=g:Select(tp,1,1,nil)
			Duel.SynchroSummon(tp,sg:GetFirst(),token)
		end        
    end
end