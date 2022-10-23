--破灭之魂 - 靛墟
local m=33701453
local cm=_G["c"..m]
function cm.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,nil,2,4,cm.lcheck)
	c:EnableReviveLimit()
	--Effect 1
	local e12=Effect.CreateEffect(c)
	e12:SetDescription(aux.Stringid(m,0))
	e12:SetCategory(CATEGORY_DAMAGE+CATEGORY_DESTROY)
	e12:SetType(EFFECT_TYPE_QUICK_O)
	e12:SetCode(EVENT_FREE_CHAIN)
	e12:SetRange(LOCATION_MZONE)
	e12:SetHintTiming(TIMING_BATTLE_START+TIMING_BATTLE_END)
	e12:SetCountLimit(1,m)
	e12:SetCondition(cm.descon)
	e12:SetTarget(cm.destg)
	e12:SetOperation(cm.desop)
	c:RegisterEffect(e12)
	if not cm.global_check then
		cm.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_DESTROYED)
		ge1:SetOperation(cm.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
--all
function cm.checkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	while tc do
		local tp1=tc:GetPreviousControler()
		Duel.RegisterFlagEffect(tp1,m,RESET_PHASE+PHASE_END,0,1)
		tc=eg:GetNext()
	end
end
--link summon
function cm.lcheck(g,lc)
	return g:IsExists(Card.IsLinkRace,1,nil,RACE_DRAGON)
end
--Effect 1  
function cm.descon(e)
	local tp=e:GetHandlerPlayer()
	local ct1=Duel.GetFlagEffect(tp,m)
	local ct2=Duel.GetFlagEffect(1-tp,m)
	return ct1>0 or ct2>0
end
function cm.check(c,atk)
	return c:GetAttack()<atk and c:IsType(TYPE_MONSTER)
end
function cm.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=e:GetHandler():GetLinkedGroup()
	if chk==0 then return #g>0 end 
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=c:GetLinkedGroup()
	if  c:IsRelateToEffect(e)
		and #g>0
		and Duel.Destroy(g,REASON_EFFECT)>0 then
		local atk=Duel.GetOperatedGroup():GetSum(Card.GetAttack)
		if atk==0 then return end
		if Duel.SelectYesNo(1-tp,aux.Stringid(m,0)) then
			local kg=Duel.GetFieldGroup(tp,0,LOCATION_DECK)
			Duel.ConfirmCards(tp,kg)
			if kg:IsExists(cm.check,1,nil,atk) then
				local xg=Group.CreateGroup()
				local mg=Duel.GetMatchingGroup(cm.check,tp,0,LOCATION_DECK,nil,atk)
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
				local dc=mg:Select(tp,1,1,nil):GetFirst()
				if dc then
				   xg:AddCard(dc)
				   mg:RemoveCard(dc)
				   atk=atk-dc:GetAttack()
				   local chk=true
				   while chk do
					   if  atk>0 and mg:IsExists(cm.check,1,nil,atk) 
						   and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
						   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
						   local tc=mg:FilterSelect(tp,cm.check,1,1,nil,atk):GetFirst()
						   xg:AddCard(tc)
						   mg:RemoveCard(tc)
						   atk=atk-tc:GetAttack()
					   else
						   chk=false
					   end
				   end
				   Duel.Destroy(xg,REASON_EFFECT)
				end 
				Duel.ShuffleDeck(1-tp)
			else
				Duel.ShuffleDeck(1-tp)
			end
		else
			Duel.Damage(1-tp,atk,REASON_EFFECT)
		end
	end
end
