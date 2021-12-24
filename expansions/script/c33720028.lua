--Sepialife - Roar in Stillness
--Scripted by:XGlitchy30
local id=33720028
local s=_G["c"..tostring(id)]
function s.initial_effect(c)
	--gift
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1)
	e1:SetCondition(s.con1)
	e1:SetTarget(s.tg1)
	e1:SetOperation(s.op1)
	c:RegisterEffect(e1)
	--draw
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_BOTH_SIDE+EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EVENT_PHASE+PHASE_BATTLE_START)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1)
	e2:SetCondition(s.con2)
	e2:SetTarget(s.tg2)
	e2:SetOperation(s.op2)
	c:RegisterEffect(e2)
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,3))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetProperty(EFFECT_FLAG_EVENT_PLAYER)
	e3:SetCode(EVENT_CUSTOM+id)
	e3:SetTarget(s.sptg)
	e3:SetOperation(s.spop)
	c:RegisterEffect(e3)
	--check revealed status
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e4:SetRange(LOCATION_HAND)
	e4:SetCode(EFFECT_SEND_REPLACE)
	e4:SetTarget(s.checkpub)
	c:RegisterEffect(e4)
	local ge1=Effect.CreateEffect(c)
	ge1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	ge1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	ge1:SetCode(EVENT_TO_GRAVE)
	ge1:SetOperation(s.check)
	c:RegisterEffect(ge1)
	--check chains
	Duel.AddCustomActivityCounter(id,ACTIVITY_CHAIN,s.chainfilter)
end
function s.check(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local p=false
	if c:IsPreviousLocation(LOCATION_HAND) and c:GetFlagEffect(id+100)>0 then
		p=c:GetPreviousControler()
	end
	if p then Duel.RaiseSingleEvent(c,EVENT_CUSTOM+id,re,r,rp,p,0) end
end
function s.chainfilter(re,tp,cid)
	return re:GetHandler():IsSetCard(0x144e)
end
--
function s.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x144e)
end
function s.con1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp and Duel.GetCustomActivityCount(id,tp,ACTIVITY_CHAIN)==0 and Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_MZONE,0,2,nil)
end
function s.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function s.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.SendtoHand(c,1-tp,REASON_EFFECT)>0 and c:IsLocation(LOCATION_HAND) and c:IsControler(1-tp) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_PUBLIC)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e1)
		Duel.ShuffleHand(tp)
	end
end
--
function s.con2(e,tp,eg,ep,ev,re,r,rp)
	return tp~=e:GetHandlerPlayer() and Duel.GetTurnPlayer()~=tp and e:GetHandler():IsPublic() and Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)<Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)
end
function s.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local diff=math.abs(Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)-Duel.GetFieldGroupCount(tp,0,LOCATION_HAND))
	if chk==0 then return diff>0 and Duel.IsPlayerCanDraw(tp,diff) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(diff)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,diff)
end
function s.op2(e,tp,eg,ep,ev,re,r,rp)
	local diff=math.abs(Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)-Duel.GetFieldGroupCount(tp,0,LOCATION_HAND))
	if diff==0 then return end
	if Duel.IsChainDisablable(0) and Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,0,LOCATION_HAND,diff,nil,REASON_EFFECT) and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_DISCARD)
		local g=Duel.SelectMatchingCard(1-tp,Card.IsDiscardable,tp,0,LOCATION_HAND,diff,diff,nil,REASON_EFFECT)
		if #g>0 and Duel.SendtoGrave(g,REASON_EFFECT+REASON_DISCARD)>0 then
			Duel.NegateEffect(0)
			return
		end
	end
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	Duel.Draw(p,diff,REASON_EFFECT)
end
--
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) and e:GetHandler():IsRelateToEffect(e) then
		Duel.SpecialSummon(e:GetHandler(),0,tp,1-tp,false,false,POS_FACEUP)
	end
end
--
function s.checkpub(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsPublic() end
	if c:IsPublic() then
		c:RegisterFlagEffect(id+100,RESET_EVENT+RESETS_STANDARD-RESET_TOGRAVE,EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_IMMUNE,1)
	end
	return false
end