--孟婆汤
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
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_REMOVE)
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
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local num=3
	if Duel.IsPlayerAffectedByEffect(tp,23410013) then
		--Duel.Hint(HINT_CARD,0,23410017)
		num=num+2
	end
	if chk==0 then return Duel.GetDecktopGroup(1-tp,num):FilterCount(Card.IsAbleToRemove,nil)==num end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,num,tp,LOCATION_DECK)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local num=3
	if Duel.IsPlayerAffectedByEffect(tp,23410013) then
		Duel.Hint(HINT_CARD,0,23410017)
		num=num+2
	end
	if Duel.GetDecktopGroup(1-tp,num):FilterCount(Card.IsAbleToRemove,nil)~=num then return end
	local g=Duel.GetDecktopGroup(1-tp,num)
	if Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT)~=0 and Duel.IsExistingMatchingCard(nil,tp,0,LOCATION_ONFIELD,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local rg=Duel.GetMatchingGroup(nil,tp,0,LOCATION_ONFIELD,nil):Select(tp,1,1,nil)
		Duel.Remove(rg,POS_FACEDOWN,REASON_EFFECT)
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