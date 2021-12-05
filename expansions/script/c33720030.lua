--Sepialife - Arrival in Departure
--Scripted by:XGlitchy30
local id=33720030
local s=_G["c"..tostring(id)]
function s.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,aux.FilterBoolFunction(Card.IsFusionSetCard,0x144e),3,true)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCountLimit(1)
	e1:SetCondition(s.con1)
	e1:SetTarget(s.tg1)
	e1:SetOperation(s.op1)
	c:RegisterEffect(e1)
	--replace
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(s.desreptg)
	e2:SetValue(s.desrepval)
	e2:SetOperation(s.desrepop)
	c:RegisterEffect(e2)
	--damage
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetCategory(CATEGORY_RECOVER)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(s.con3)
	e3:SetTarget(s.tg3)
	e3:SetOperation(s.op3)
	c:RegisterEffect(e3)
end
--
function s.cfilter(c)
	return c:IsSetCard(0x144e) and c:IsPublic()
end
function s.con1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp and Duel.GetActivityCount(tp,ACTIVITY_BATTLE_PHASE)==0 and Duel.IsExistingMatchingCard(s.cfilter,tp,0,LOCATION_HAND,2,nil)
end
function s.matfilter(c)
	return c:IsSetCard(0x144e) and c:IsType(TYPE_MONSTER) and c:IsAbleToDeck()
end
function s.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(s.matfilter,tp,LOCATION_GRAVE,0,3,nil) and Duel.GetLocationCountFromEx(tp,tp,nil,e:GetHandler())>0 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false)
	end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,3,tp,LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function s.op1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.matfilter),tp,LOCATION_GRAVE,0,3,3,nil)
	if #g>0 then
		Duel.HintSelection(g)
		if Duel.SendtoDeck(g,nil,2,REASON_EFFECT)>0 and g:FilterCount(Card.IsLocation,nil,LOCATION_DECK+LOCATION_EXTRA)==#g and Duel.GetLocationCountFromEx(tp,tp,nil,e:GetHandler())>0 and e:GetHandler():IsRelateToEffect(e) then
			local cg=g:Filter(Card.IsLocation,nil,LOCATION_DECK)
			if #cg>0 then
				for p=0,1 do
					if cg:IsExists(Card.IsControler,1,nil,p) then
						Duel.ShuffleDeck(p)
					end
				end
			end
			Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
--
function s.repfilter(c,tp)
	return c:IsSetCard(0x144e) and c:IsReason(REASON_BATTLE+REASON_EFFECT) and not c:IsReason(REASON_REPLACE) and c:GetReasonPlayer()==1-tp and (not c:IsOnField() or c:IsFaceup())
end
function s.dryfilter(c,e)
	return c:IsPublic() and c:IsSetCard(0x144e) and c:IsDestructable(e) and not c:IsStatus(STATUS_DESTROY_CONFIRMED)
end
function s.desreptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=eg:Filter(s.repfilter,nil,tp)
	if chk==0 then
		return #g>0 and Duel.IsExistingMatchingCard(s.dryfilter,tp,0,LOCATION_HAND,#g,nil,e)
	end
	if Duel.SelectEffectYesNo(tp,e:GetHandler(),96) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESREPLACE)
		local sg=Duel.SelectMatchingCard(tp,s.dryfilter,tp,0,LOCATION_HAND,#g,#g,nil,e)
		sg:KeepAlive()
		e:SetLabelObject(sg)
		for tc in aux.Next(sg) do
			tc:SetStatus(STATUS_DESTROY_CONFIRMED,true)
		end
		return true
	end
	return false
end
function s.desrepval(e,c)
	return s.repfilter(c,e:GetHandlerPlayer())
end
function s.desrepop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,id)
	local tg=e:GetLabelObject()
	if not tg then return end
	for tc in aux.Next(tg) do
		tc:SetStatus(STATUS_DESTROY_CONFIRMED,false)
	end
	Duel.Destroy(tg,REASON_EFFECT+REASON_REPLACE)
	tg:DeleteGroup()
end
--
function s.con3(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==1-tp
end
function s.tg3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.cfilter,tp,0,LOCATION_HAND,1,nil) end
	Duel.SetTargetPlayer(tp)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,0)
end
function s.op3(e,tp,eg,ep,ev,re,r,rp)
	local rt=Duel.GetMatchingGroupCount(s.cfilter,tp,0,LOCATION_HAND,nil)*800
	if rt<=0 then return end
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	Duel.Recover(p,rt,REASON_EFFECT)
end