--魔力联合 魅影鬼姬
function c33200431.initial_effect(c)
	c:SetUniqueOnField(1,0,33200431)
	--cannot special summon
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(c33200431.splimit)
	c:RegisterEffect(e0)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,33200431+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c33200431.spcon)
	e1:SetOperation(c33200431.sprop)
	c:RegisterEffect(e1)
	--can't Activate
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e6:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e6:SetCode(EVENT_CHAINING)
	e6:SetRange(LOCATION_MZONE)
	e6:SetOperation(aux.chainreg)
	c:RegisterEffect(e6)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCode(EVENT_CHAIN_SOLVED)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetOperation(c33200431.actop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCode(EFFECT_CANNOT_ACTIVATE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(0,1)
	e3:SetCondition(c33200431.condition)
	e3:SetValue(c33200431.aclimit)
	c:RegisterEffect(e3)
	--to hand
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetOperation(c33200431.regop)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_PHASE+PHASE_END)
	e5:SetRange(LOCATION_GRAVE)
	e5:SetCountLimit(1,33200432)
	e5:SetCondition(c33200431.thcon)
	e5:SetTarget(c33200431.thtg)
	e5:SetOperation(c33200431.thop)
	c:RegisterEffect(e5)  
end

--spsm
function c33200431.splimit(e,se,sp,st)
	return se:IsHasType(EFFECT_TYPE_ACTIONS)
end
function c33200431.thspfilter(c,ft)
	return c:IsFaceup() and c:IsSetCard(0x3329) and c:IsAbleToHandAsCost()
		 and (ft>0 or c:GetSequence()<5)
end

function c33200431.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	return ft>-1 and Duel.IsExistingMatchingCard(c33200431.thspfilter,tp,LOCATION_MZONE,0,1,nil,ft) and
		Duel.GetMatchingGroupCount(Card.IsType,c:GetControler(),0,LOCATION_GRAVE+LOCATION_REMOVED,nil,TYPE_SPELL)>=5
end
function c33200431.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectMatchingCard(tp,c33200431.thspfilter,tp,LOCATION_MZONE,0,1,1,nil,ft)
	Duel.SendtoHand(g,nil,REASON_COST)
end

--e2
function c33200431.actop(e,tp,eg,ep,ev,re,r,rp)
	if re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:IsActiveType(TYPE_SPELL) and e:GetHandler():GetFlagEffect(1)>0 then
		e:GetHandler():RegisterFlagEffect(33200431,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
		e:GetHandler():RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(33200431,0))
	end
end
function c33200431.condition(e)
	return e:GetHandler():GetFlagEffect(33200431)==0 and Duel.GetMatchingGroupCount(Card.IsType,tp,LOCATION_GRAVE,0,nil,TYPE_SPELL)==0
end
function c33200431.aclimit(e,re,tp)
	return re:IsActiveType(TYPE_MONSTER)
end

--e4
function c33200431.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	c:RegisterFlagEffect(33200432,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
end
function c33200431.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(33200432)>0
end
function c33200431.thfilter(c)
	return c:IsAbleToHand() and c:IsSetCard(0x3329) and not c:IsCode(33200431)
end
function c33200431.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c33200431.thfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
end
function c33200431.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c33200431.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	local tc=g:GetFirst()
	if tc and tc:IsAbleToHand() then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end