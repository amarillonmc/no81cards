--Sepialife - Departure in Arrival
--Scripted by:XGlitchy30
local id=33720029
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
	--discard limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_ADJUST)
	e2:SetRange(LOCATION_MZONE)
	e2:SetOperation(s.hlim)
	c:RegisterEffect(e2)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e5:SetRange(LOCATION_MZONE)
	e5:SetTargetRange(0,1)
	e5:SetCode(EFFECT_CANNOT_DISCARD_HAND)
	e5:SetTarget(s.tg2)
	e5:SetValue(1)
	c:RegisterEffect(e5)
	--damage
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetCategory(CATEGORY_DAMAGE)
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
function s.hlim(e,tp,eg,ep,ev,re,r,rp)
	local check=false
	local eset={Duel.IsPlayerAffectedByEffect(1-tp,EFFECT_HAND_LIMIT)}
	for _,ce in ipairs(eset) do
		if ce and ce.SetLabelObject and ce:GetLabel()~=id then
			if not check then check=true end
			local val
			local lim=ce:GetValue()
			if type(lim)=="number" then
				val=lim-1
			elseif type(lim)=="function" then
				val=lim(ce)-1
			end
			if type(val)=="number" then
				if val<0 then val=0 end
				if e:GetLabel() and val==e:GetLabel() then return end
				local prevlim=e:GetLabelObject()
				if prevlim and prevlim.SetLabelObject then
					prevlim:Reset()
				end
				local c=e:GetHandler()
				local e4=Effect.CreateEffect(c)
				e4:SetType(EFFECT_TYPE_FIELD)
				e4:SetCode(EFFECT_HAND_LIMIT)
				e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
				e4:SetRange(LOCATION_MZONE)
				e4:SetTargetRange(0,1)
				e4:SetLabel(id)
				e4:SetValue(val)
				c:RegisterEffect(e4)
				e:SetLabel(val)
				e:SetLabelObject(e4)
			end
		end
	end
	if not check then
		if e:GetLabel() and e:GetLabel()==5 then return end
		local prevlim=e:GetLabelObject()
		if prevlim and prevlim.SetLabelObject then
			prevlim:Reset()
		end
		local c=e:GetHandler()
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_FIELD)
		e4:SetCode(EFFECT_HAND_LIMIT)
		e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e4:SetRange(LOCATION_MZONE)
		e4:SetTargetRange(0,1)
		e4:SetLabel(id)
		e4:SetValue(5)
		c:RegisterEffect(e4)
		e:SetLabel(val)
		e:SetLabelObject(e4)
	end
end
function s.tg2(e,c)
	return c:IsSetCard(0x144e) and c:IsControler(1-e:GetHandlerPlayer())
end
--
function s.con3(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==1-tp and Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)==0
end
function s.tg3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(1000)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,1000)
end
function s.op3(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end