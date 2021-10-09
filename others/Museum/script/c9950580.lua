--fate·暗杀者卫宫
function c9950580.initial_effect(c)
 --draw
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9950580,0))
	e2:SetCategory(CATEGORY_DRAW+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCountLimit(1,9950580)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCost(c9950580.drcost)
	e2:SetTarget(c9950580.drtg2)
	e2:SetOperation(c9950580.drop2)
	c:RegisterEffect(e2)
	--draw
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(9950580,2))
	e7:SetCategory(CATEGORY_DRAW)
	e7:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e7:SetProperty(EFFECT_FLAG_DELAY)
	e7:SetCode(EVENT_TO_GRAVE)
	e7:SetCountLimit(1)
	e7:SetCondition(c9950580.drcon)
	e7:SetTarget(c9950580.drtg)
	e7:SetOperation(c9950580.drop)
	c:RegisterEffect(e7)
--spsummon bgm
	 local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	e8:SetOperation(c9950580.sumsuc)
	c:RegisterEffect(e8)
	local e9=e8:Clone()
	e9:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e9)
end
function c9950580.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(9950580,0))
end
function c9950580.drcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetCode(EFFECT_SKIP_DP)
	e1:SetReset(RESET_PHASE+PHASE_END+RESET_SELF_TURN,2)
	Duel.RegisterEffect(e1,tp)
end
function c9950580.drtg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c9950580.drop2(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	if Duel.Draw(p,d,REASON_EFFECT)~=0 then
		local tc=Duel.GetOperatedGroup():GetFirst()
		Duel.ConfirmCards(1-tp,tc)
		Duel.BreakEffect()
		if tc:IsType(TYPE_MONSTER) and tc:IsSetCard(0x6ba6) then
			if Duel.GetLocationCount(tp,LOCATION_MZONE)>0
				and Duel.SelectYesNo(tp,aux.Stringid(9950580,1))
				and Duel.SpecialSummonStep(tc,0,tp,tp,true,false,POS_FACEUP) then
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_DIRECT_ATTACK)
				e1:SetValue(1)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
				tc:RegisterEffect(e1,true)
				Duel.SpecialSummonComplete()
			end
		end
		Duel.ShuffleHand(tp)
	end
  Duel.Hint(HINT_MUSIC,0,aux.Stringid(9950580,0))
end
function c9950580.drcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c9950580.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c9950580.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
  Duel.Hint(HINT_MUSIC,0,aux.Stringid(9950580,0))
end