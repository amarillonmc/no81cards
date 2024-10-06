--神威如龙
local s,id=GetID()
function s.initial_effect(c)
	  aux.AddCodeList(c,64836050)
	 --Effect 3 act in set turn
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
	e0:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e0:SetCondition(s.actcon)
	c:RegisterEffect(e0)
		 --Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,1))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id)
	e1:SetCost(s.cost)
	e1:SetTarget(s.settg)
	e1:SetOperation(s.setop)
	c:RegisterEffect(e1)
 --Activate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,2))
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCondition(s.tdcon)
	e2:SetOperation(s.tdop)
	c:RegisterEffect(e2)
	
end
--
function s.actcon(e)
	local c=e:GetHandler()
	local tp=e:GetHandlerPlayer()
	return c:GetTurnID()==Duel.GetTurnCount() and Duel.GetTurnPlayer()==1-tp and Duel.GetFlagEffect(tp,64836050)>0
end
--
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,500)  end
	Duel.PayLPCost(tp,500)
end
function s.setfilter(c)
	return aux.IsCodeListed(c,64836050)  and c:IsType(TYPE_SPELL+TYPE_TRAP) and  c:IsSSetable()
end
function s.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
		return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>4
	end
	Duel.SetTargetPlayer(tp)
end
function s.setop(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	Duel.ConfirmDecktop(p,5)
	local g=Duel.GetDecktopGroup(p,5)
	if g:GetCount()>0 and g:IsExists(s.setfilter,1,nil) then
		Duel.Hint(HINT_SELECTMSG,p,HINTMSG_SET)
		local tc=g:FilterSelect(tp,s.setfilter,1,1,nil):GetFirst()
		if tc then  
		   Duel.SSet(tp,tc)
		   Duel.ConfirmCards(1-tp,tc)
		end
	end
	Duel.ShuffleDeck(p)
end
--
function s.tdcon(e,tp,eg,ep,ev,re,r,rp)
	return  Duel.GetFlagEffect(tp,64836050)>0
end
function s.tdop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
		e1:SetTargetRange(LOCATION_ONFIELD,0)
		e1:SetReset(RESET_PHASE+PHASE_END)
		e1:SetValue(s.indesval)
		Duel.RegisterEffect(e1,tp)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
		e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
		e2:SetTargetRange(LOCATION_ONFIELD,0)
		e2:SetValue(1)
		e2:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e2,tp)
		local e3=Effect.CreateEffect(e:GetHandler())
		e3:SetType(EFFECT_TYPE_FIELD)
		e3:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
		e3:SetCode(EFFECT_CANNOT_REMOVE)
		e3:SetTargetRange(LOCATION_ONFIELD,0)
		e3:SetTarget(s.rmlimit)
		e3:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e3,tp)
	local ct=Duel.GetCurrentChain()
	local tep=nil
	if ct>1 then tep=Duel.GetChainInfo(Duel.GetCurrentChain()-1,CHAININFO_TRIGGERING_PLAYER) end
	if ct>1 and tep and tep==1-tp and Duel.SelectYesNo(tp,aux.Stringid(id,3)) then 
		local g=Group.CreateGroup()
		Duel.ChangeTargetCard(ct-1,g)
		Duel.ChangeChainOperation(ct-1,s.repop)
	end
end
function s.indesval(e,re,rp)
	return rp~=e:GetHandlerPlayer()
end
function s.rmlimit(e,c,tp,r)
	return r==REASON_EFFECT
end
function s.repop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Remove(c,POS_FACEUP,REASON_EFFECT)
end





