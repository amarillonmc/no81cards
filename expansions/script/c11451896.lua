--炼狱之结界像
local cm,m=GetID()
function cm.initial_effect(c)
	--disable spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,1)
	e1:SetTarget(cm.sumlimit)
	c:RegisterEffect(e1)
	--remove
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetCountLimit(1,m)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_BOTH_SIDE)
	e0:SetRange(LOCATION_MZONE)
	e0:SetCondition(cm.recon)
	e0:SetOperation(cm.reop)
	c:RegisterEffect(e0)
	local e2=e0:Clone()
	e2:SetCondition(cm.recon2)
	Duel.RegisterEffect(e2,0)
	local e4=e2:Clone()
	Duel.RegisterEffect(e4,1)
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_CUSTOM+m)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetTarget(cm.sptg)
	e3:SetOperation(cm.spop)
	c:RegisterEffect(e3)
	--replace
	local e5=Effect.CreateEffect(c)
	e5:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EVENT_PHASE_START+PHASE_DRAW)
	e5:SetCountLimit(1,11451896+EFFECT_COUNT_CODE_DUEL)
	e5:SetRange(LOCATION_HAND+LOCATION_DECK)
	e5:SetOperation(cm.rep)
	c:RegisterEffect(e5)
end
function cm.rep(e,tp,eg,ep,ev,re,r,rp)
	local table={19740112,10963799,47961808,73356503,46145256,84478195}
	for i,code in ipairs(table) do
		local cn=_G["c"..code]
		if type(cn)=="table" and type(cn.sumlimit)=="function" then
			cn.sumlimit=function(e,c,sump,sumtype,sumpos,targetp)
							return not c:IsAttribute(1<<(i-1))
						end
		end
		local g=Duel.GetMatchingGroup(aux.FilterEqualFunction(Card.GetOriginalCode,code),0,0xff,0xff,nil)
		for tc in aux.Next(g) do tc:ReplaceEffect(code,0) end
	end
end
function cm.sumlimit(e,c,sump,sumtype,sumpos,targetp)
	return c:GetAttribute()&(ATTRIBUTE_WATER+ATTRIBUTE_FIRE)==0
end
function cm.recon(e,tp,eg,ep,ev,re,r,rp)
	return (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2) and Duel.GetTurnPlayer()==tp and Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil)
end
function cm.recon2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsLocation(LOCATION_MZONE) and c:IsFaceup() and c:IsControler(1-tp) and (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2) and Duel.GetTurnPlayer()==tp and Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil)
end
function cm.reop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local sg=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(sg,POS_FACEUP,REASON_COST)
	Duel.RaiseSingleEvent(c,EVENT_CUSTOM+m,e,0,0,0,sg:GetFirst():GetAttribute())
end
function cm.filter(c)
	return c:IsAbleToRemoveAsCost() and c:IsType(TYPE_MONSTER)
end
function cm.cclfilter(c,tc)
	local seq1=aux.GetColumn(c)
	local seq2=aux.GetColumn(tc)
	return seq1 and seq2 and math.abs(seq1-seq2)==1
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(cm.cclfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,e:GetHandler())
	g:AddCard(e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,2,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,cm.cclfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil,e:GetHandler())
	if not g or #g==0 then return end
	g:AddCard(c)
	if Duel.Destroy(g,REASON_EFFECT)>0 then
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp,ev)
		if #g>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
function cm.spfilter(c,e,tp,attr)
	return c:IsAttribute(attr) and c:IsAttack(1000) and c:IsDefense(1000) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end