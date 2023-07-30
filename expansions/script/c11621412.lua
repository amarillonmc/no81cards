--桃源乡的乐不思蜀
local m=11621412
local cm=_G["c"..m]
function c11621412.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	--ntr
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CONTINUOUS_TARGET)
	e2:SetHintTiming(0,TIMING_END_PHASE+TIMINGS_CHECK_MONSTER)
	e2:SetCountLimit(1,m)
	e2:SetCondition(cm.ntrcon)
	e2:SetTarget(cm.ntrtg)
	e2:SetOperation(cm.ntrop)
	c:RegisterEffect(e2)
	--tohand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,3))
	e3:SetCategory(CATEGORY_DRAW)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_RELEASE)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,m*2+1)
	e3:SetTarget(cm.thtg)
	e3:SetOperation(cm.thop)
	c:RegisterEffect(e3)
	cm[c]=e3  
	--
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_UNRELEASABLE_SUM)
	e4:SetValue(cm.sumlimit)
	c:RegisterEffect(e4)  
end
cm.SetCard_THY_PeachblossomCountry=true 
--
function cm.sumlimit(e,c)
	return not c:IsRace(RACE_ZOMBIE)
end
--
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,m,0,TYPES_EFFECT_TRAP_MONSTER,1100,900,3,RACE_ZOMBIE,ATTRIBUTE_LIGHT) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
		or not Duel.IsPlayerCanSpecialSummonMonster(tp,m,0,TYPES_EFFECT_TRAP_MONSTER,1100,900,3,RACE_ZOMBIE,ATTRIBUTE_LIGHT) then return end
	c:AddMonsterAttribute(TYPE_EFFECT+TYPE_TRAP)
	Duel.SpecialSummon(c,SUMMON_VALUE_SELF,tp,tp,true,false,POS_FACEUP)
	--local g=Duel.GetMatchingGroup(Card.IsFacedown,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	--if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
	--	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEDOWN)
	--	local ag=Duel.SelectMatchingCard(tp,Card.IsFacedown,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	--	if ag:GetCount()>0 then
	--		Duel.HintSelection(ag)
	--		Duel.BreakEffect()
	--		Duel.Release(ag,REASON_EFFECT)
	--	end
	--end
end
--02
function cm.ntrfilter(c)
	return c.SetCard_THY_PeachblossomCountry and c:IsFaceup() and c:IsType(TYPE_RITUAL) and c:IsType(TYPE_MONSTER)
end
function cm.ntrcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SPECIAL+SUMMON_VALUE_SELF and Duel.IsExistingMatchingCard(cm.ntrfilter,tp,LOCATION_MZONE,0,1,nil)
end
function cm.ntrtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chk==0 then return c:IsSSetable() end
end
function cm.ntrop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()  
	if c:IsSSetable() then
		Duel.SSet(tp,c)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
		local selected_zone=Duel.SelectField(tp,1,0,LOCATION_ONFIELD,nil)
		--Card.GetSequence()
		--Debug.Message("设备运行良好！选择的区域是："..selected_zone)
		if selected_zone~=0 then 
			local e1 = Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_CONTINUOUS)
			e1:SetCode(EVENT_TO_GRAVE)
			e1:SetLabel(selected_zone)
			e1:SetCondition(function(e, tp, eg, ep, ev, re, r, rp)
				return eg:IsExists(function(c)
					local nseq=c:GetPreviousSequence()--+16
					--Debug.Message("设备运行良好！选择的区域是："..nseq)
					local loc=LOCATION_MZONE 
					if bit.band(selected_zone,0x1f001f)~=0 then loc=LOCATION_MZONE end
					if bit.band(selected_zone,0x1f001f00)~=0 then loc=LOCATION_SZONE end
					if bit.band(selected_zone,0x20002000)~=0 then loc=LOCATION_FZONE end
					--Debug.Message("设备运行良好！选择的区域是："..loc)
					local seq=0
					if selected_zone==65536 or selected_zone==65536*(2^8) then
						seq=0
					elseif selected_zone==65536*2 or selected_zone==65536*(2^9) then
						seq=1
					elseif selected_zone==65536*4 or selected_zone==65536*(2^10) then
						seq=2  
					elseif selected_zone==65536*9 or selected_zone==65536*(2^11) then
						seq=3 
					elseif selected_zone==65536*16 or selected_zone==65536*(2^12) then
						seq=4  
					else
						seq=5 
					end
					return c:IsPreviousLocation(loc) and c:GetPreviousControler()~=tp and nseq==seq
				end,1,nil)
			end)
			e1:SetOperation(function(e, tp, eg, ep, ev, re, r, rp)
				Duel.Hint(HINT_CARD,0,m) 
				Duel.Draw(tp,1,REASON_EFFECT)
			end)
			e1:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e1,tp)
		end
	end
end
--03
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Draw(tp,1,REASON_EFFECT)
end
