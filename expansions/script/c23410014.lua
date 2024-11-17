--汤盆冲击
local cm,m,o=GetID()
function cm.initial_effect(c)
	aux.AddCodeList(c,23410013)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_REMOVE+CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	--negate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,3))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_REMOVE)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,m)
	e2:SetCondition(cm.effcon)
	e2:SetTarget(cm.efftg)
	e2:SetOperation(cm.effop)
	c:RegisterEffect(e2)
end
function cm.spfilter(c,tp)
	local num=c:GetLevel()
	return c:IsType(TYPE_RITUAL) and aux.IsCodeListed(c,23410013) and c:IsType(TYPE_MONSTER)
		and ((Duel.GetMatchingGroupCount(Card.IsFacedown,tp,0,LOCATION_REMOVED,nil)>=num and Duel.GetMatchingGroupCount(Card.IsFacedown,tp,0,LOCATION_REMOVED,nil)<10) or (Duel.GetMatchingGroupCount(Card.IsFacedown,tp,0,LOCATION_REMOVED,nil)>=10 and Duel.GetDecktopGroup(1-tp,num):FilterCount(Card.IsAbleToRemove,nil)==num))
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,tp)
	if g:GetCount()>0 then
		if Duel.GetMatchingGroupCount(Card.IsFacedown,tp,0,LOCATION_REMOVED,nil)>=10 then
			local g=Duel.GetDecktopGroup(1-tp,g:GetFirst():GetLevel())
			Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT)
		else
			local g=Duel.GetMatchingGroup(Card.IsFacedown,tp,0,LOCATION_REMOVED,nil):RandomSelect(tp,g:GetFirst():GetLevel())
			Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
		end
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		g:GetFirst():CompleteProcedure()
	end
end
function cm.cfilter(c,tp)
	return c:IsFacedown() and c:GetControler()==1-tp
end
function cm.effcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.cfilter,1,nil,tp)
		and aux.exccon(e,tp,eg,ep,ev,re,r,rp)
end
function cm.efftg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function cm.effop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.SendtoHand(e:GetHandler(),nil,REASON_EFFECT)~=0 and e:GetHandler():CheckActivateEffect(true,true,false)~=nil
		and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
		local te,ceg,cep,cev,cre,cr,crp=e:GetHandler():CheckActivateEffect(true,true,true)
		if te then
			e:SetLabelObject(te:GetLabelObject())
			local op=te:GetOperation()
			if op then op(e,tp,eg,ep,ev,re,r,rp) end
		end
	end
end