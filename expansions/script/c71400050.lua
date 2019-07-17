--黑白的异梦引导
xpcall(function() require("expansions/script/c71400001") end,function() require("script/c71400001") end)
function c71400050.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c71400050.tg1)
	e1:SetCondition(yume.YumeCon)
	e1:SetOperation(c71400050.op1)
	e1:SetDescription(aux.Stringid(71400050,0))
	e1:SetCountLimit(1,71400050)
	c:RegisterEffect(e1)
	--destroy replace
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,71500050)
	e2:SetCondition(yume.YumeCon)
	e2:SetTarget(c71400050.tg2)
	e2:SetValue(c71400050.repval)
	e2:SetOperation(c71400050.op2)
	c:RegisterEffect(e2)
end
function c71400050.filter1(c)
	return c:IsSetCard(0x717) and c:IsAbleToHand()
end
function c71400050.filter1a(c)
	return c:IsSetCard(0x714) and c:IsType(TYPE_TUNER) and c:IsAbleToHand()
end
function c71400050.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c71400050.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c71400050.op1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c71400050.filter1,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 and Duel.SendtoHand(g,nil,REASON_EFFECT)~=0 then
		Duel.ConfirmCards(1-tp,g)
		local thg=Duel.GetMatchingGroup(c71400050.filter1a,tp,LOCATION_GRAVE,0,nil)
		if thg:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(71400050,1)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local sc=thg:Select(tp,1,1,nil):GetFirst()
			Duel.SendtoHand(sc,nil,REASON_EFFECT)
		end
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c71400050.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c71400050.splimit(e,c)
	return not c:IsType(TYPE_SYNCHRO) and c:IsLocation(LOCATION_EXTRA)
end
function c71400050.filter2(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x714)
		and c:IsOnField() and c:IsControler(tp) and c:IsReason(REASON_EFFECT+REASON_BATTLE) and not c:IsReason(REASON_REPLACE)
end
function c71400050.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemove() and eg:IsExists(c71400050.filter2,1,nil,tp) end
	return Duel.SelectEffectYesNo(tp,e:GetHandler(),96)
end
function c71400050.repval(e,c)
	return c71400050.filter2(c,e:GetHandlerPlayer())
end
function c71400050.op2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT)
end