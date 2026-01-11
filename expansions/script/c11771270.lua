--堕落王子 渡鸦
local s,id,o=GetID()
function s.initial_effect(c)
	
	-- 这张卡不能通常召唤，用战士族怪兽的效果才能特殊召唤
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(s.splimit)
	c:RegisterEffect(e1)
	
	-- 有怪兽特殊召唤的场合发动，这张卡从手卡往自己或对方的场上特殊召唤
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1,id)
	e2:SetTarget(s.sptg)
	e2:SetOperation(s.spop)
	c:RegisterEffect(e2)
	
	-- 这张卡特殊召唤的场合发动，掷1次骰子，出现的数目的以下效果适用
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetCategory(CATEGORY_DICE+CATEGORY_DRAW+CATEGORY_TOGRAVE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCountLimit(1,id+1)
	e3:SetTarget(s.eftg)
	e3:SetOperation(s.efop)
	c:RegisterEffect(e3)
	
	-- 表侧表示的这张卡从场上离开的场合发动，进行1次投掷硬币
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(9047460,0))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_COIN)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_LEAVE_FIELD)
	e4:SetCondition(s.coincon)
	e4:SetTarget(s.cointg)
	e4:SetOperation(s.coinop)
	c:RegisterEffect(e4)
end

-- 这张卡不能通常召唤，用战士族怪兽的效果才能特殊召唤
function s.splimit(e,se,sp,st)
	return se:IsActiveType(TYPE_MONSTER) and se:GetHandler():IsRace(RACE_WARRIOR)
end

-- 有怪兽特殊召唤的场合发动，这张卡从手卡往自己或对方的场上特殊召唤
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		or Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,1-tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end

function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or (not c:IsCanBeSpecialSummoned(e,0,tp,false,false) and not c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,1-tp)) then return end
	local b1=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
	local b2=Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,1-tp)
	local toplayer=aux.SelectFromOptions(tp,
		{b1,aux.Stringid(id,3),tp},
		{b2,aux.Stringid(id,4),1-tp})
	if toplayer~=nil then
		Duel.SpecialSummon(c,0,tp,toplayer,false,false,POS_FACEUP)
	else
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 and Duel.GetLocationCount(1-tp,LOCATION_MZONE)<=0 then
			Duel.SendtoGrave(c,REASON_RULE)
		end
	end
end

-- 这张卡特殊召唤的场合发动，掷1次骰子，出现的数目的以下效果适用
function s.eftg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DICE,nil,0,tp,1)
end

function s.efop(e,tp,eg,ep,ev,re,r,rp)
	local dc=Duel.TossDice(tp,1)
	local c=e:GetHandler()
	if dc==1 then
    local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_FIELD)
        e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
        e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
        e1:SetTargetRange(LOCATION_MZONE,0)
        e1:SetValue(1)
        e1:SetReset(RESET_PHASE+PHASE_END)
        Duel.RegisterEffect(e1,tp)
	elseif dc==2 then
		if Duel.IsPlayerCanDraw(tp,3) then
			Duel.Draw(tp,3,REASON_EFFECT)
		end
	elseif dc==3 then
		local g=Duel.GetMatchingGroup(Card.IsAbleToGrave,tp,0,LOCATION_ONFIELD,nil)
		if #g>0 then
			Duel.SendtoGrave(g,REASON_EFFECT)
		end
	elseif dc==4 then
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_FIELD)
        e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
        e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
        e1:SetTargetRange(0,LOCATION_MZONE)
        e1:SetValue(1)
        e1:SetReset(RESET_PHASE+PHASE_END)
        Duel.RegisterEffect(e1,tp)
	elseif dc==5 then
		if Duel.IsPlayerCanDraw(1-tp,3) then
			Duel.Draw(1-tp,3,REASON_EFFECT)
		end
	elseif dc==6 then
		local g=Duel.GetMatchingGroup(Card.IsAbleToGrave,tp,LOCATION_ONFIELD,0,nil)
		if #g>0 then
			Duel.SendtoGrave(g,REASON_EFFECT)
		end
	end
end

-- 表侧表示的这张卡从场上离开的场合发动，进行1次投掷硬币
function s.coincon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousPosition(POS_FACEUP)
end

function s.cointg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_COIN,nil,0,tp,1)
end

function s.coinop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local coin = Duel.TossCoin(tp,1)
	local sp_owner = (coin==1) and tp or 1-tp
	local orig_loc = c:GetLocation()
	c:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD,0,1)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e1:SetCountLimit(1)
	e1:SetLabelObject(c)
	e1:SetValue(orig_loc)
	e1:SetCondition(s.spcon1)
	e1:SetOperation(s.spop1)
	if Duel.GetCurrentPhase()==PHASE_STANDBY then
		e1:SetLabel(Duel.GetTurnCount())
		e1:SetReset(RESET_PHASE+PHASE_STANDBY,2)
	else
		e1:SetLabel(0)
		e1:SetReset(RESET_PHASE+PHASE_STANDBY)
	end
	Duel.RegisterEffect(e1,sp_owner)
end

function s.spcon1(e,tp,eg,ep,ev,re,r,rp)
	local c = e:GetLabelObject()
	local orig_loc = e:GetValue()
	return Duel.GetTurnCount()~=e:GetLabel()
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c and c:GetFlagEffect(id)>0
		and c:IsLocation(orig_loc)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end

function s.spop1(e,tp,eg,ep,ev,re,r,rp)
	local c = e:GetLabelObject()
	local orig_loc = e:GetValue()
	if not (c and c:GetFlagEffect(id)>0 and c:IsLocation(orig_loc)) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_CARD,0,id)
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end
