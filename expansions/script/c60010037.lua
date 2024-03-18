--血源猎手 狂舞的血色波纹
local cm,m,o=GetID()
function cm.initial_effect(c)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetRange(LOCATION_HAND)
	e1:SetCode(EVENT_ADJUST)
	e1:SetCondition(cm.rcon)
	e1:SetOperation(cm.rop)
	c:RegisterEffect(e1)
	--
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,0))
	e3:SetCategory(CATEGORY_DRAW)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_REMOVED)
	e3:SetCountLimit(1,m)
	e3:SetTarget(cm.otg)
	e3:SetOperation(cm.oop)
	c:RegisterEffect(e3)
end
cm.toss_dice=true
function cm.rcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsLocation(LOCATION_HAND) and e:GetHandler():IsAbleToRemove()
end
function cm.rop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.Remove(c,POS_FACEUP,REASON_EFFECT)~=0 and Duel.GetFieldGroupCount(e:GetHandlerPlayer(),LOCATION_HAND,0)<=1 then
		Duel.Draw(e:GetHandlerPlayer(),1,REASON_EFFECT)
	end
	Duel.Readjust()
end
function cm.otg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.GetFieldGroupCount(e:GetHandlerPlayer(),LOCATION_DECK,0)>0 end
end
function cm.oop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local x=Duel.TossDice(tp,1)
	Duel.Draw(tp,x,REASON_EFFECT)
	Duel.BreakEffect()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local hg=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_HAND,0,nil):Select(tp,x,x,nil)
	Duel.SendtoDeck(hg,tp,0,REASON_EFFECT)
	
	local hg=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_HAND,0,nil)
	local fst=false
	local scd=false
	local trd=false
	
	if not hg:IsExists(Card.IsType,1,nil,TYPE_TRAP) then fst=true end
	if not hg:IsExists(Card.IsType,1,nil,TYPE_SPELL) then scd=true end
	if not hg:IsExists(Card.IsType,1,nil,TYPE_MONSTER) then trd=true end
	
	if fst==true then   
		Duel.ConfirmDecktop(tp,x)
		local hhg=Duel.GetDecktopGroup(tp,x)
		local dg=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
		if Duel.Destroy(dg,REASON_EFFECT)~=0 then
			local num=math.min(#Duel.GetOperatedGroup(),#hhg)
			Duel.SendtoHand(hhg:Select(tp,num,num,nil),1-tp,REASON_EFFECT)
		end
	end

	if scd==true then
		Duel.ConfirmDecktop(tp,x)
		local hhg=Duel.GetDecktopGroup(tp,x)
		local num=hhg:Filter(Card.IsType,nil,TYPE_SPELL)
		if num~=0 then
			local g=Duel.GetFieldGroup(tp,0,LOCATION_EXTRA)
			Duel.ConfirmCards(tp,g)
			local rg=g:Select(tp,num,num,nil)
			Duel.Remove(rg,POS_FACEUP,REASON_EFFECT)
		end
	end
	if trd==true then
		local hg1=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_HAND,0,nil)
		local hg2=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_HAND,nil)
		if #hg1~=0 then
			Duel.SendtoHand(hg1,1-tp,REASON_RULE)
		end
		if #hg2~-0 then
			Duel.SendtoHand(hg2,tp,REASON_RULE)
		end
		local hg3=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_HAND,0,nil)
		local hg4=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_HAND,nil)
		if #hg3>7 then
			local num1=#hg3-7
			Duel.DiscardHand(tp,aux.TRUE,num1,num1,REASON_EFFECT,nil)
		elseif #hg3<7 then
			local num1=7-#hg3
			Duel.Draw(tp,num1,REASON_EFFECT)
		end
		if #hg4>7 then
			local num2=#hg4-7
			Duel.DiscardHand(1-tp,aux.TRUE,num2,num2,REASON_EFFECT,nil)
		elseif #hg4<7 then
			local num2=7-#hg4
			Duel.Draw(1-tp,num2,REASON_EFFECT)
		end
	end
end
