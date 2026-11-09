--牺牲前来
function c33740000.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_DAMAGE+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	--e1:SetCountLimit(1,33740000+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c33740000.target)
	e1:SetOperation(c33740000.activate)
	c:RegisterEffect(e1)
end
function c33740000.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local b1=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=3 and Duel.IsPlayerCanRemove(tp)
	local b2=true
	local op=aux.SelectFromOptions(1-tp,
		{b1,aux.Stringid(33740000,0)},
		{b2,aux.Stringid(33740000,1)})
	e:SetLabel(op)
end
function c33740000.gcheck(sg)
	return sg:IsExists(Card.IsAttribute,1,nil,ATTRIBUTE_FIRE) or sg:IsExists(Card.IsRace,1,nil,RACE_PYRO)
end
function c33740000.activate(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabel()==1 then
		local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_DECK,0,nil)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local sg=g:SelectSubGroup(tp,c33740000.gcheck,false,3,3)
		if not sg or #sg==0 or Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)==0 then return end
	else
		local dis=Duel.SelectField(tp,3,LOCATION_MZONE,0,0xe000e0)
		Duel.Hint(HINT_ZONE,tp,dis)
		if tp==1 then
			dis=((dis&0xffff)<<16)|((dis>>16)&0xffff)
		end
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_DISABLE_FIELD)
		e1:SetValue(dis)
		e1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
		Duel.RegisterEffect(e1,tp)
	end
	local b1=true
	local b2=Duel.IsPlayerCanDraw(tp,3)
	local op=aux.SelectFromOptions(1-tp,
		{b1,aux.Stringid(33740000,2)},
		{b2,aux.Stringid(33740000,3)})
	if op==1 then
		Duel.Damage(1-tp,2000,REASON_EFFECT)
	else
		Duel.Draw(tp,3,REASON_EFFECT)
	end
end
