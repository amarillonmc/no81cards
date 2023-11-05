--罪都的支配者 哈伊卡·拉伊卡
local cm,m,o=GetID()
function cm.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(cm.spcon)
	e1:SetOperation(cm.spop)
	c:RegisterEffect(e1)
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetTarget(cm.thtg)
	e1:SetOperation(cm.thop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
end
function cm.fil(c)
	return c:IsType(TYPE_FIELD) and c:IsAbleToRemoveAsCost()
end
function cm.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(cm.fil,tp,LOCATION_HAND,0,1,c) and Duel.IsExistingMatchingCard(cm.fil,tp,LOCATION_GRAVE,0,1,c) and Duel.IsExistingMatchingCard(cm.fil,tp,LOCATION_DECK,0,1,c) end
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local g=Duel.SelectMatchingCard(tp,cm.fil,tp,LOCATION_HAND,0,1,1,c)
	local g2=Duel.SelectMatchingCard(tp,cm.fil,tp,LOCATION_DECK,0,1,1,c)
	local g3=Duel.SelectMatchingCard(tp,cm.fil,tp,LOCATION_GRAVE,0,1,1,c)
	g1:Merge(g2)
	g1:Merge(g3)
	Duel.Remove(g1,POS_FACEUP,REASON_COST+REASON_DISCARD)
end
function cm.spcheck(g)
	return g:GetClassCount(Card.GetCode)==g:GetCount()
end
function cm.thfilter(c)
	return c:IsSetCard(0x6aa) and c:IsType(TYPE_FIELD) and c:IsAbleToHand()
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(cm.thfilter,tp,LOCATION_DECK,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local hg=g:SelectSubGroup(tp,cm.spcheck,false,1,ft)
	if hg:GetCount()>0 and Duel.SendtoHand(hg,nil,REASON_EFFECT)~=0 then 
		Duel.ConfirmCards(1-tp,hg)
		if Duel.GetFlagEffect(tp,m)==0 then
			Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,0,1)
			local c=e:GetHandler()
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e1:SetCode(EVENT_SPSUMMON_SUCCESS)
			e1:SetCondition(cm.regcon)
			e1:SetOperation(cm.regop)
			e1:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e1,tp)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e2:SetCode(EVENT_SUMMON_SUCCESS)
			e2:SetCondition(cm.regcon)
			e2:SetOperation(cm.regop)
			e2:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e2,tp)
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e3:SetCode(EVENT_PHASE+PHASE_END)
			e3:SetCountLimit(1)
			e3:SetCondition(cm.effcon)
			e3:SetOperation(cm.effop)
			e3:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e3,tp)
			e1:SetLabelObject(e3)
			e2:SetLabelObject(e3)
		end
	end
end
function cm.regop(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetLabelObject():GetLabel()
	e:GetLabelObject():SetLabel(ct+1)
end
function cm.cfilter(c,tp)
	return c:IsSummonPlayer(tp) and c:IsSetCard(0x6aa)
end
function cm.regcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.cfilter,1,nil,tp)
end
function cm.effcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetLabel()>0
end
function cm.effop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,46448938)
	Duel.Draw(tp,e:GetLabel(),REASON_EFFECT)
end