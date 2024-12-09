--徇世罔燃
local cm,m,o=GetID()
function cm.initial_effect(c)
	aux.AddCodeList(c,60000032)
	--act in hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	c:RegisterEffect(e2)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DAMAGE+CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	--destroy replace
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetTarget(cm.reptg)
	e2:SetValue(cm.repval)
	e2:SetOperation(cm.repop)
	c:RegisterEffect(e2)
end
function cm.repfilter(c,tp)
	return c:IsFaceup() and c:IsCode(60000032)
		and c:IsOnField() and c:IsControler(tp) and c:IsReason(REASON_EFFECT+REASON_BATTLE) and not c:IsReason(REASON_REPLACE)
end
function cm.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemove() and eg:IsExists(cm.repfilter,1,nil,tp) end
	return Duel.SelectEffectYesNo(tp,e:GetHandler(),96)
end
function cm.repval(e,c)
	return cm.repfilter(c,e:GetHandlerPlayer())
end
function cm.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT)
end
function cm.filter(c)
	return aux.IsCodeListed(c,60000032) and c:IsAbleToHand()
end
function cm.lkfil(c)
	return c:IsType(TYPE_SPELL) or c:IsType(TYPE_TRAP)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(cm.filter,e:GetHandlerPlayer(),LOCATION_DECK,0,nil)
	local tg=Duel.GetMatchingGroup(cm.lkfil,e:GetHandlerPlayer(),LOCATION_HAND,0,nil)
	g:Merge(tg)
	if e:GetActivateLocation()~=LOCATION_HAND then
		e:SetLabel(1)
	end
	if chk==0 then return e:GetLabel()~=1
		or (g:GetClassCount(Card.GetCode)>1 and Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_DECK,0,1,nil)
		and Duel.IsExistingMatchingCard(cm.lkfil,tp,LOCATION_HAND,0,1,nil)) end
	
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,tp,100)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(cm.filter,e:GetHandlerPlayer(),LOCATION_DECK,0,nil)
	local tg=Duel.GetMatchingGroup(cm.lkfil,e:GetHandlerPlayer(),LOCATION_HAND,0,nil)
	g:Merge(tg)
	
	if Duel.Damage(tp,100,REASON_EFFECT)~=0 and e:GetLabel()==1 
		and g:GetClassCount(Card.GetCode)>1 and Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_DECK,0,1,nil)
		and Duel.IsExistingMatchingCard(cm.lkfil,tp,LOCATION_HAND,0,1,nil) then
		local dg=Duel.GetMatchingGroup(cm.filter,tp,LOCATION_DECK,0,nil)
		local hg=Group.CreateGroup()
		local shg=Duel.GetMatchingGroup(cm.lkfil,tp,LOCATION_HAND,0,nil)
		local uvg=Group.CreateGroup()
		uvg:Merge(dg)
		uvg:Merge(shg)
		local i=0
		while i<2 do
			i=i+1
			if uvg:GetClassCount(Card.GetCode)>1 and #shg>0 and #dg>0 then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
				local rc=shg:Select(tp,1,1,nil):GetFirst()
				hg:AddCard(rc)
				dg:Remove(Card.IsCode,nil,rc:GetCode())
				uvg:Remove(Card.IsCode,nil,rc:GetCode())
				shg:RemoveCard(rc)
			end
			if i==1 and not Duel.SelectYesNo(tp,aux.Stringid(m,1)) then i=i+10 end
		end
		Duel.ConfirmCards(1-tp,hg)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local thg=dg:Select(tp,#hg,#hg,nil)
		if Duel.SendtoHand(thg,nil,REASON_EFFECT)~=0 then Duel.SendtoDeck(hg,nil,1,REASON_EFFECT) end
	end
end










