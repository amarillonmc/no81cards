--狩猎游戏
function c33700101.initial_effect(c)
	 --Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
   --self destroy
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_SELF_TOGRAVE)
	e1:SetCondition(c33700101.con)
	c:RegisterEffect(e1)
	--tohand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(45950291,0))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_PREDRAW)
	e2:SetRange(LOCATION_HAND)
	e2:SetCondition(c33700101.thcon)
	e2:SetTarget(c33700101.thtg)
	e2:SetOperation(c33700101.thop)
	c:RegisterEffect(e2)
end
c33700101.card_code_list={33700056}
function c33700101.filter(c)
	return c:IsSetCard(0x442) 
end
function c33700101.filter2(c)
	return not  c:IsSetCard(0x442) 
end
function c33700101.con(e)
	 local g=Duel.GetMatchingGroup(nil,e:GetHandlerPlayer(),LOCATION_GRAVE,0,nil)
	return g:GetClassCount(Card.GetCode)<g:GetCount() or not Duel.IsExistingMatchingCard(c33700101.filter,e:GetHandlerPlayer(),LOCATION_GRAVE,0,1,nil)
end
function c33700101.thcon(e,tp,eg,ep,ev,re,r,rp)
	return tp==Duel.GetTurnPlayer() and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>2
		and Duel.GetDrawCount(tp)>0
end
function c33700101.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
	  local g=Duel.GetDecktopGroup(tp,3)
		local result=g:FilterCount(Card.IsAbleToHand,nil)>0
		return result 
	   end
	local dt=Duel.GetDrawCount(tp)
	if dt~=0 then
		_replace_count=0
		_replace_max=dt
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetCode(EFFECT_DRAW_COUNT)
		e1:SetTargetRange(1,0)
		e1:SetReset(RESET_PHASE+PHASE_DRAW)
		e1:SetValue(0)
		Duel.RegisterEffect(e1,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,2,tp,LOCATION_DECK)
end
function c33700101.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
   if not c:IsRelateToEffect(e) then return end
	_replace_count=_replace_count+1
	if _replace_count<=_replace_max  then
	 Duel.ConfirmDecktop(tp,3)
	local g=Duel.GetDecktopGroup(tp,3)
	if g:GetCount()>0 then
	   local sg2=g:Filter(tp,c33700101.filter2,nil)
	 if g:IsExists(c33700101.filter,1,nil) then
		Duel.DisableShuffleCheck() 
	   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Filter(tp,c33700101.filter,nil)
			 if sg:GetFirst():IsAbleToHand() then
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sg)
			Duel.ShuffleHand(tp)
		if sg:GetClassCount(Card.GetCode)<sg:GetCount() then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetTargetRange(1,0)
		e1:SetCode(EFFECT_SKIP_DP)
		e1:SetReset(RESET_PHASE+PHASE_DRAW+RESET_SELF_TURN)
		Duel.RegisterEffect(e1,tp)
end
		   else
				Duel.SendtoGrave(sg,REASON_EFFECT)
			end
end
		  Duel.MoveSequence(sg2,1)
   end
end
end
