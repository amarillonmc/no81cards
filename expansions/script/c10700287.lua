--雾之谷的龙神
function c10700287.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x7c3),aux.NonTuner(nil),1)
	c:EnableReviveLimit()  
	--ShuffleDeck
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10700287,0))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,10700287)
	e1:SetCondition(c10700287.shcon1)
	e1:SetOperation(c10700287.shop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,10700287)
	e2:SetCondition(c10700287.shcon2)
	e2:SetOperation(c10700287.shop)
	c:RegisterEffect(e2)
	--special summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(10700287,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_PHASE+PHASE_DRAW)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,10700288)
	e3:SetTarget(c10700287.target)
	e3:SetOperation(c10700287.operation)
	c:RegisterEffect(e3)  
end
function c10700287.shcon1(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsPlayerAffectedByEffect(tp,10700291)
end
function c10700287.shcon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsPlayerAffectedByEffect(tp,10700291)
end
function c10700287.shop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.ShuffleDeck(tp)
end
function c10700287.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CARDTYPE)
	e:SetLabel(Duel.AnnounceType(tp))
	Duel.SetChainLimit(c10700287.chlimit)
end
function c10700287.chlimit(e,ep,tp)
	return tp==ep
end
function c10700287.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)==0 then return end
	Duel.ConfirmDecktop(tp,1)
	local g=Duel.GetDecktopGroup(tp,1)
	local tc=g:GetFirst()
	local opt=e:GetLabel()
	if (opt==0 and tc:IsType(TYPE_MONSTER)) or (opt==1 and tc:IsType(TYPE_SPELL)) or (opt==2 and tc:IsType(TYPE_TRAP)) then
			 local e1=Effect.CreateEffect(c)
			 e1:SetType(EFFECT_TYPE_FIELD)
			 e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
			 e1:SetCode(EFFECT_CANNOT_ACTIVATE)
			 e1:SetTargetRange(0,1)
			 if e:GetLabel()==0 then
				 e1:SetDescription(aux.Stringid(10700287,2))
				 e1:SetValue(c10700287.aclimit1)
			 elseif e:GetLabel()==1 then
			 e1:SetDescription(aux.Stringid(10700287,3))
			 e1:SetValue(c10700287.aclimit2)
			 else
			 e1:SetDescription(aux.Stringid(10700287,4))
			 e1:SetValue(c10700287.aclimit3)
			 end
			 e1:SetReset(RESET_PHASE+PHASE_END)
			 Duel.RegisterEffect(e1,tp)
	  end
end 
function c10700287.aclimit1(e,re,tp)
	return re:IsActiveType(TYPE_MONSTER)
end
function c10700287.aclimit2(e,re,tp)
	return re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:IsActiveType(TYPE_SPELL)
end
function c10700287.aclimit3(e,re,tp)
	return re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:IsActiveType(TYPE_TRAP)
end 