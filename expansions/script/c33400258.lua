--本条二亚的被窝突袭
function c33400258.initial_effect(c)
	  --activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	 --DIRECT_ATTACK
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetCode(EFFECT_DIRECT_ATTACK)
	e2:SetTarget(c33400258.datg)
	c:RegisterEffect(e2)
	--to grave
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_TOGRAVE)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetCode(EVENT_BATTLE_DAMAGE)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCountLimit(1,33400258)
	e4:SetCondition(c33400258.tgcon)
	e4:SetTarget(c33400258.tgtg)
	e4:SetOperation(c33400258.tgop)
	c:RegisterEffect(e4)
	  --confirm TP
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_DRAW)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetCountLimit(1,33400258+10000)
	e3:SetOperation(c33400258.operation2)
	c:RegisterEffect(e3)
end
function c33400258.datg(e,c)
	return c:IsSetCard(0x341) and c:IsAttackBelow(1000)
end
function c33400258.tgcon(e,tp,eg,ep,ev,re,r,rp)
	local rc=eg:GetFirst()
	return ep~=tp and rc:IsControler(tp) and rc:IsSetCard(0x6342)
end
function c33400258.tgtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsOnField() and chkc:IsAbleToGrave() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToGrave,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectTarget(tp,Card.IsAbleToGrave,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,0,0)
end
function c33400258.tgop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		if Duel.SendtoGrave(tc,REASON_EFFECT)~=0 and  tc:IsType(TYPE_MONSTER)  then		
				Duel.Damage(1-tp,tc:GetBaseAttack()/2,REASON_EFFECT)		   
		end
	end
end
function c33400258.operation2(e,tp,eg,ep,ev,re,r,rp)
		local cm=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)
		if cm>2 then cm=2 end
		local g=Duel.GetDecktopGroup(tp,cm)
		  Duel.ConfirmCards(tp,g)
		  Duel.SortDecktop(tp,tp,cm)
end