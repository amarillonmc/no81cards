--死冥之渊 塔尔塔罗斯
local s,id,o=GetID()
function s.initial_effect(c)
	aux.EnableExtraDeckSummonCountLimit()
	--发动
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_DECKDES)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e1:SetOperation(s.tgop)
	c:RegisterEffect(e1)
	--送去墓地    
    local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(2,id)
	e2:SetCondition(s.rtgcon)
	e2:SetTarget(s.rtgtg)
	e2:SetOperation(s.rtgop)
	c:RegisterEffect(e2)
	--特召限制    
    local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetTargetRange(1,0)
	e3:SetTarget(s.splimit)
	c:RegisterEffect(e3)
	--额外自肃    
    local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e4:SetRange(LOCATION_SZONE)
	e4:SetTargetRange(1,0)
	e4:SetTarget(s.exsplimit)
	c:RegisterEffect(e4)           
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
    e5:SetRange(LOCATION_SZONE)
	e5:SetOperation(s.excheckop)
    c:RegisterEffect(e5)    
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e6:SetRange(LOCATION_SZONE)
	e6:SetCode(92345028)
	e6:SetTargetRange(1,0)
	c:RegisterEffect(e6)
end
function s.tgfilter(c)
	return c:IsSetCard(0x364b) and c:IsAbleToGrave()
end
function s.tgop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(s.tgfilter,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoGrave(sg,REASON_EFFECT)		
	end
end
function s.cfilter(c,tp)
	return c:IsType(TYPE_MONSTER) and c:IsPreviousControler(tp) and c:IsPreviousLocation(LOCATION_MZONE) and c:IsReason(REASON_EFFECT)
    	and c:IsPreviousSetCard(0x364b)
end
function s.rtgcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.cfilter,1,nil,tp)
end
function s.rtgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)>0 end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,1-tp,LOCATION_MZONE)
end
function s.rtgop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsType,1-tp,LOCATION_MZONE,0,nil,TYPE_MONSTER)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_TOGRAVE)
		local sg=g:Select(1-tp,1,1,nil)
		Duel.HintSelection(sg)
        local tc=sg:GetFirst()
		if Duel.SendtoGrave(tc,REASON_RULE,1-tp)~=0 then   
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e1:SetCode(EFFECT_CANNOT_ACTIVATE)
			e1:SetTargetRange(0,1)
			e1:SetValue(s.aclimit)
			e1:SetLabelObject(tc)
			e1:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e1,tp)
        end    
	end
end
function s.aclimit(e,re,tp)
	local rc=re:GetHandler()
	local tc=e:GetLabelObject()
	return re:IsActiveType(TYPE_MONSTER) and rc:IsOriginalCodeRule(tc:GetOriginalCodeRule())
end
function s.splimit(e,c)
	return not c:IsLocation(LOCATION_GRAVE+LOCATION_EXTRA)
end
function s.exsplimit(e,c,sump,sumtype,sumpos,targetp,se)
	return c:IsLocation(LOCATION_EXTRA) and aux.ExtraDeckSummonCountLimit[sump]<=0
end
function s.excfilter(c,tp)
	return c:IsSummonPlayer(tp) and c:IsPreviousLocation(LOCATION_EXTRA)
end
function s.excheckop(e,tp,eg,ep,ev,re,r,rp)
	if eg:IsExists(s.excfilter,1,nil,tp) then
		aux.ExtraDeckSummonCountLimit[tp]=aux.ExtraDeckSummonCountLimit[tp]-1
	end
	if eg:IsExists(s.excfilter,1,nil,1-tp) then
		aux.ExtraDeckSummonCountLimit[1-tp]=aux.ExtraDeckSummonCountLimit[1-tp]-1
	end
end