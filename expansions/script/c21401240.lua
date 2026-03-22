--幻爆術
local s,id=GetID()
local BURST_BODY_SET=0x104f

function s.initial_effect(c)
	aux.AddCodeList(c,80280737)

	--全局：追踪同调怪兽效果发动，连锁结束后抛出自定义事件
	if not s.global_check then
		s.global_check=true
		s.synchro_data={[0]={}, [1]={}}

		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		ge1:SetCode(EVENT_CHAINING)
		ge1:SetOperation(s.trackop)
		Duel.RegisterEffect(ge1,0)

		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		ge2:SetCode(EVENT_CHAIN_END)
		ge2:SetOperation(s.raiseop)
		Duel.RegisterEffect(ge2,0)
	end

	--自己场上有同调怪兽存在的场合，这张卡在盖放的回合也能发动
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e0:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
	e0:SetCondition(s.actcon)
	c:RegisterEffect(e0)

	--①
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CUSTOM+id)
	e1:SetCondition(s.spcon)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)

	--②
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e2:SetCountLimit(1,id+1)
	e2:SetCondition(s.thcon)
	e2:SetTarget(s.thtg)
	e2:SetOperation(s.thop)
	c:RegisterEffect(e2)
end

----------------------------------------------------------------
-- 全局追踪（记录发动时属性）
----------------------------------------------------------------
function s.trackop(e,tp,eg,ep,ev,re,r,rp)
	if not re then return end
	local rc=re:GetHandler()
	if not rc then return end
	if not re:IsActiveType(TYPE_MONSTER) then return end
	if not rc:IsType(TYPE_SYNCHRO) then return end
	local loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
	if loc&LOCATION_MZONE==0 then return end
	-- 在发动时记录属性
	local att=rc:GetAttribute()
	table.insert(s.synchro_data[rp],{card=rc, att=att})
end

function s.raiseop(e,tp,eg,ep,ev,re,r,rp)
	for p=0,1 do
		if #s.synchro_data[p]>0 then
			local g=Group.CreateGroup()
			local att=0
			for _,data in ipairs(s.synchro_data[p]) do
				g:AddCard(data.card)
				att=att|data.att
			end
			-- 把发动时的合并属性通过 ev 参数传递
			Duel.RaiseEvent(g,EVENT_CUSTOM+id,e,0,p,p,att)
		end
		s.synchro_data[p]={}
	end
end

----------------------------------------------------------------
-- 盖放回合可发动
----------------------------------------------------------------
function s.synfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_SYNCHRO)
end
function s.actcon(e)
	local tp=e:GetHandlerPlayer()
	return Duel.IsExistingMatchingCard(s.synfilter,tp,LOCATION_MZONE,0,1,nil)
end

----------------------------------------------------------------
-- ①
----------------------------------------------------------------
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp
end

function s.spfilter(c,e,tp,att)
	return c:IsSetCard(BURST_BODY_SET) and c:IsType(TYPE_MONSTER)
		and c:IsAttribute(att)
		and c:IsCanBeSpecialSummoned(e,0,tp,true,true)
end

function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	-- ev = 发动时的合并属性（由 raiseop 传入）
	local att=ev
	e:SetLabel(att)
	if chk==0 then
		return att~=0
			and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			and Duel.IsExistingMatchingCard(aux.NecroValleyFilter(s.spfilter),tp,
				LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp,att)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE)
end

function s.retcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if not tc or tc:GetFlagEffectLabel(id)~=e:GetLabel() then
		e:Reset()
		return false
	end
	return true
end

function s.retop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc and tc:IsLocation(LOCATION_MZONE) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end

function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local att=e:GetLabel()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.spfilter),tp,
		LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp,att):GetFirst()
	if not tc then return end
	if Duel.SpecialSummon(tc,0,tp,tp,true,true,POS_FACEUP_DEFENSE)~=0 then
		tc:CompleteProcedure()

		local fid=e:GetHandler():GetFieldID()
		tc:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD,0,1,fid)

		--结束阶段回到手卡
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetCountLimit(1)
		e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetLabel(fid)
		e1:SetLabelObject(tc)
		e1:SetCondition(s.retcon)
		e1:SetOperation(s.retop)
		Duel.RegisterEffect(e1,tp)

		--从场上离开的场合回到手卡
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e2:SetValue(LOCATION_HAND)
		e2:SetReset(RESET_EVENT+RESETS_REDIRECT)
		tc:RegisterEffect(e2,true)
	end
end

----------------------------------------------------------------
-- ②
----------------------------------------------------------------
function s.thcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()~=PHASE_DAMAGE
end

function s.thfilter(c)
	return c:IsFaceup()
		and c:IsType(TYPE_MONSTER)
		and (c:IsSetCard(BURST_BODY_SET) or c:IsType(TYPE_SYNCHRO))
		and c:IsAbleToHand()
end

function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then
		return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_REMOVED) and s.thfilter(chkc)
	end
	if chk==0 then
		return c:IsAbleToHand()
			and Duel.IsExistingTarget(s.thfilter,tp,LOCATION_REMOVED,0,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,s.thfilter,tp,LOCATION_REMOVED,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end

function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	local g=Group.CreateGroup()
	if c:IsRelateToEffect(e) then
		g:AddCard(c)
	end
	if tc and tc:IsRelateToEffect(e) then
		g:AddCard(tc)
	end
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
	end
end
