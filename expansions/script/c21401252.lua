--幻爆术的燃剑侍
local s,id=GetID()
local BURST_BODY_SET=0x104f

function s.initial_effect(c)
	--Synchro summon：「幻爆术」调整＋调整以外的怪兽1只以上
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x3d71),aux.NonTuner(nil),1)
	c:EnableReviveLimit()

	--①：这张卡特殊召唤的场合才能发动。
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.atttg)
	e1:SetOperation(s.attop)
	c:RegisterEffect(e1)

	--②：自己·对方回合才能发动。
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e2:SetCountLimit(1,id+1)
	e2:SetTarget(s.tdtg)
	e2:SetOperation(s.tdop)
	c:RegisterEffect(e2)

	--③：破坏代替
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,2))
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_DESTROY_REPLACE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,id+2)
	e3:SetTarget(s.reptg)
	e3:SetOperation(s.repop)
	c:RegisterEffect(e3)
end

----------------------------------------------------------------
-- ①
----------------------------------------------------------------
function s.atttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end

function s.atkfilter(e,c)
	return c:IsFaceup() and c:IsAttribute(e:GetLabel())
end

function s.attop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	--宣言属性（效果处理）
	local att=Duel.AnnounceAttribute(tp,1,ATTRIBUTE_ALL)

	--直到回合结束：自己场上宣言属性怪兽攻击力+800
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(s.atkfilter)
	e1:SetLabel(att)
	e1:SetValue(800)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)

	--那之后，可以让这张卡变成宣言的属性
	Duel.BreakEffect()
	if c:IsFaceup() and c:IsRelateToEffect(e)
		and Duel.SelectYesNo(tp,aux.Stringid(id,3)) then
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_CHANGE_ATTRIBUTE)
		e2:SetValue(att)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		c:RegisterEffect(e2)
	end
end

----------------------------------------------------------------
-- ②
----------------------------------------------------------------
function s.tdfilter(c)
	if not c:IsType(TYPE_MONSTER) then return false end
	if not (c:IsType(TYPE_SYNCHRO) or c:IsSetCard(BURST_BODY_SET)) then return false end
	if c:IsLocation(LOCATION_MZONE+LOCATION_REMOVED) and not c:IsFaceup() then return false end
	if c:IsType(TYPE_SYNCHRO) then
		return c:IsAbleToExtra()
	else
		return c:IsAbleToDeck()
	end
end

function s.tdselcheck(sg)
	return sg:FilterCount(Card.IsLocation,nil,LOCATION_MZONE)<=1
		and sg:FilterCount(Card.IsLocation,nil,LOCATION_GRAVE)<=1
		and sg:FilterCount(Card.IsLocation,nil,LOCATION_REMOVED)<=1
end

function s.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(s.tdfilter,tp,LOCATION_MZONE+LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_MZONE+LOCATION_GRAVE+LOCATION_REMOVED)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end

function s.tdop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(s.tdfilter,tp,LOCATION_MZONE+LOCATION_GRAVE+LOCATION_REMOVED,0,nil)
	if #g==0 then return end
	local maxsel=math.min(3,#g)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local sg=g:SelectSubGroup(tp,s.tdselcheck,false,1,maxsel)
	if not sg or #sg==0 then return end
	Duel.HintSelection(sg)
	local ct=Duel.SendtoDeck(sg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	if ct>0 then
		Duel.BreakEffect()
		Duel.Draw(tp,ct,REASON_EFFECT)
	end
end

----------------------------------------------------------------
-- ③
----------------------------------------------------------------
function s.repfilter(c)
	return c:IsType(TYPE_SYNCHRO) and c:IsAbleToGrave()
end
function s.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:IsReason(REASON_BATTLE+REASON_EFFECT)
			and not c:IsReason(REASON_REPLACE)
			and Duel.IsExistingMatchingCard(s.repfilter,tp,LOCATION_EXTRA,0,1,nil)
	end
	if not Duel.SelectYesNo(tp,aux.Stringid(id,2)) then return false end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,s.repfilter,tp,LOCATION_EXTRA,0,1,1,nil)
	local tc=g:GetFirst()
	e:SetLabelObject(tc)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,tc,1,0,0)
	return true
end
function s.repop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	e:SetLabelObject(nil)
	if tc then
		Duel.SendtoGrave(tc,REASON_EFFECT+REASON_REPLACE)
	end
end
