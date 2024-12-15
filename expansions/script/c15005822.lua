local m=15005822
local cm=_G["c"..m]
cm.name="天翎渊的气合"
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(cm.target)
	c:RegisterEffect(e1)
	--atk
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x5f43))
	e2:SetValue(cm.atkval)
	c:RegisterEffect(e2)
	--indes
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x5f43))
	e3:SetValue(1)
	c:RegisterEffect(e3)
	--draw and discard
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_HANDES+CATEGORY_DRAW)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCountLimit(1,m+1)
	e4:SetTarget(cm.drtg)
	e4:SetOperation(cm.drop)
	c:RegisterEffect(e4)
end
function cm.thfilter(c,e,tp)
	return c:IsSetCard(0x5f43) and c:IsType(TYPE_MONSTER) and (c:IsAbleToHand() or (Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)))
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and cm.thfilter(chkc,e,tp) end
	if chk==0 then return true end
	if Duel.IsExistingTarget(cm.thfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp)
		and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
		e:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
		e:SetProperty(EFFECT_FLAG_CARD_TARGET)
		e:SetOperation(cm.activate)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
		local g=Duel.SelectTarget(tp,cm.thfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
	else
		e:SetCategory(0)
		e:SetProperty(0)
		e:SetOperation(nil)
	end
end
function cm.pubfilter(c)
	return c:IsSetCard(0x5f43) and not c:IsPublic()
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and (tc:IsAbleToHand() or tc:IsCanBeSpecialSummoned(e,0,tp,false,false)) then
		local b1=tc:IsAbleToHand()
		local b2=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and tc:IsCanBeSpecialSummoned(e,0,tp,false,false)
		local op=aux.SelectFromOptions(tp,{b1,1190},{b2,1152})
		local res=false
		if op==1 then
			res=Duel.SendtoHand(tc,nil,REASON_EFFECT)>0
		end
		if op==2 then
			res=Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)>0
		end
		if res and Duel.IsExistingMatchingCard(cm.pubfilter,tp,LOCATION_HAND,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,2))
			local pc=Duel.SelectMatchingCard(tp,cm.pubfilter,tp,LOCATION_HAND,0,1,1,nil):GetFirst()
			if pc then
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetDescription(66)
				e1:SetCode(EFFECT_PUBLIC)
				e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
				pc:RegisterEffect(e1)
			end
		end
	end
end
function cm.atkval(e,c)
	return Duel.GetMatchingGroupCount(Card.IsPublic,c:GetControler(),LOCATION_HAND,0,nil)*500
end
function cm.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) and Duel.IsPlayerCanDraw(1-tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,PLAYER_ALL,1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,PLAYER_ALL,1)
end
function cm.drop(e,tp,eg,ep,ev,re,r,rp)
	local h1=Duel.Draw(tp,1,REASON_EFFECT)
	local h2=Duel.Draw(1-tp,1,REASON_EFFECT)
	if h1>0 or h2>0 then Duel.BreakEffect() end
	if h1>0 then
		Duel.ShuffleHand(tp)
		Duel.DiscardHand(tp,aux.TRUE,1,1,REASON_EFFECT+REASON_DISCARD)
	end
	if h2>0 then
		Duel.ShuffleHand(1-tp)
		Duel.DiscardHand(1-tp,aux.TRUE,1,1,REASON_EFFECT+REASON_DISCARD)
	end
end