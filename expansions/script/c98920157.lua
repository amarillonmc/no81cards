--核成杀戮骑士
function c98920157.initial_effect(c)
		--link summon
	aux.AddLinkProcedure(c,nil,2,2,c98920157.lcheck)
	c:EnableReviveLimit()   
 --cost
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c98920157.mtcon)
	e1:SetOperation(c98920157.mtop)
	c:RegisterEffect(e1)   
 --atk
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c98920157.atkval)
	c:RegisterEffect(e1)  
  --attack all
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_ATTACK_ALL)
	e4:SetValue(1)
	c:RegisterEffect(e4)	
--draw
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_PHASE+PHASE_BATTLE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(c98920157.thtg)
	e3:SetOperation(c98920157.thop)
	c:RegisterEffect(e3)   
 --destroy reg
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_BATTLE_DESTROYING)
	e2:SetOperation(c98920157.regop)
	c:RegisterEffect(e2)
end
function c98920157.lcheck(g,lc)
	return g:IsExists(Card.IsLinkSetCard,1,nil,0x1d)
end
function c98920157.mtcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c98920157.cfilter1(c)
	return c:IsCode(36623431) and c:IsAbleToGraveAsCost()
end
function c98920157.cfilter2(c)
	return c:IsType(TYPE_MONSTER) and c:IsRace(RACE_WARRIOR) and not c:IsPublic()
end
function c98920157.mtop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.HintSelection(Group.FromCards(c))
	local g1=Duel.GetMatchingGroup(c98920157.cfilter1,tp,LOCATION_HAND,0,nil)
	local g2=Duel.GetMatchingGroup(c98920157.cfilter2,tp,LOCATION_HAND,0,nil)
	local select=2
	Duel.Hint(HINT_SELECTMSG,tp,0)
	if g1:GetCount()>0 and g2:GetCount()>0 then
		select=Duel.SelectOption(tp,aux.Stringid(98920157,0),aux.Stringid(98920157,1),aux.Stringid(98920157,2))
	elseif g1:GetCount()>0 then
		select=Duel.SelectOption(tp,aux.Stringid(98920157,0),aux.Stringid(98920157,2))
		if select==1 then select=2 end
	elseif g2:GetCount()>0 then
		select=Duel.SelectOption(tp,aux.Stringid(98920157,1),aux.Stringid(98920157,2))+1
	else
		select=Duel.SelectOption(tp,aux.Stringid(98920157,2))
		select=2
	end
	if select==0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=g1:Select(tp,1,1,nil)
		Duel.SendtoGrave(g,REASON_COST)
	elseif select==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
		local g=g2:Select(tp,1,1,nil)
		Duel.ConfirmCards(1-tp,g)
		Duel.ShuffleHand(tp)
	else
		Duel.Destroy(c,REASON_COST)
	end
end
function c98920157.atkfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x1d) and c:GetBaseAttack()>=0
end
function c98920157.atkval(e,c)
	local lg=c:GetLinkedGroup():Filter(c98920157.atkfilter,nil)
	return lg:GetSum(Card.GetBaseAttack)
end
function c98920157.thfilter(c)
	return c:IsCode(36623431) and c:IsAbleToHand()
end
function c98920157.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=e:GetHandler():GetFlagEffectLabel(98920157)
	local g=Duel.GetMatchingGroup(c98920157.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,nil)
	if chk==0 then return ct and g:GetCount()>0 end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c98920157.thop(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetHandler():GetFlagEffectLabel(98920157)
	local g=Duel.GetMatchingGroup(c98920157.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,nil)
	if ct and g:GetCount()>0 then		
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:SelectSubGroup(tp,aux.dncheck,false,1,ct)
		if sg:GetCount()>0 then
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sg)
		end
	end
end
function c98920157.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToBattle() then return end
	local ct=c:GetFlagEffectLabel(98920157)
	if ct then
		c:SetFlagEffectLabel(98920157,ct+1)
	else
		c:RegisterFlagEffect(98920157,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1,1)
	end
end