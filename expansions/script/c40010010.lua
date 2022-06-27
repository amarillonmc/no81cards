--纯真之珠玉圣骑 爱什莉
local m=40010010
local cm=_G["c"..m]
cm.named_with_JewelPaladin=1
function cm.JewelPaladin(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_JewelPaladin
end
function cm.initial_effect(c)
	--spsummon cost
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_SPSUMMON_COST)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED)
	e0:SetOperation(cm.jpop)
	c:RegisterEffect(e0)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_LEAVE_FIELD)
	e1:SetOperation(cm.op)
	c:RegisterEffect(e1)
	--Activate
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,m)
	e1:SetCost(cm.cost)
	e2:SetTarget(cm.target)
	e2:SetOperation(cm.operation)
	c:RegisterEffect(e2)
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,1))
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_CUSTOM+m)
	e3:SetRange(LOCATION_HAND+LOCATION_GRAVE+LOCATION_REMOVED)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e3:SetTarget(cm.tdtg)
	e3:SetOperation(cm.tdop)
	c:RegisterEffect(e3)
end
function cm.jpfilter(c)
	return  c:IsType(TYPE_MONSTER)
end
function cm.jpop(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(cm.jpfilter,tp,LOCATION_MZONE,0,nil)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<=-1 then return end
	--if Duel.GetFlagEffect(tp,m+2)>0 then return end
	if sg:GetCount()>0 and ft>0 then
		if  Duel.SelectYesNo(tp,aux.Stringid(m,2)) then
			local g=Duel.SelectReleaseGroup(tp,cm.jpfilter,1,1,nil)
			Duel.Release(g,REASON_COST)
			Duel.BreakEffect()
			Duel.Draw(tp,1,REASON_EFFECT)
			e:GetHandler():RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD,0,1)
		end
	else
		local g=Duel.SelectReleaseGroup(tp,cm.jpfilter,1,1,nil)
		Duel.Release(g,REASON_COST)
		Duel.BreakEffect()
		Duel.Draw(tp,1,REASON_EFFECT)
		e:GetHandler():RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD,0,1)
	end
	--e:GetLabelObject():SetLabel(0)
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,2,nil) end
	Duel.DiscardHand(tp,Card.IsDiscardable,2,2,REASON_COST+REASON_DISCARD)
end
function cm.spfilter(c,e,tp)
	return cm.JewelPaladin(c) and c:IsLevelBelow(6) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.tgfilter(c,e,tp)
	return c:IsFaceup() 
		and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp,c) and c:IsAbleToGrave() and Duel.GetMZoneCount(tp,c)>0
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return (Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp)) or (Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 and Duel.IsExistingMatchingCard(cm.tgfilter,tp,LOCATION_MZONE,0,1,nil,e,tp) and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp)) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local cb=1
	if e:GetHandler():GetFlagEffect(m)>0 and not Duel.IsPlayerAffectedByEffect(tp,59822133) then cb=2 end
	local ct=math.min(1,cb)
	local g=Duel.GetMatchingGroup(cm.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,nil,e,tp)
	if g:GetCount()>0 and ft>=ct then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:SelectSubGroup(tp,aux.dncheck,false,1,ct)
		if sg then
			Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
		end
	else
		local tg=Duel.SelectMatchingCard(tp,cm.tgfilter,tp,LOCATION_MZONE,0,ct,ct,nil,e,tp)
		if Duel.Release(tg,REASON_COST) ~=0  then
			Duel.RegisterFlagEffect(tp,m,RESET_EVENT+0x1fe0000+RESET_CHAIN,EFFECT_FLAG_OATH,1)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sg=g:SelectSubGroup(tp,aux.dncheck,false,1,ct)
			if sg then
				Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
			end
		end
	end
	Duel.ResetFlagEffect(tp,m)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	--Debug.Message("0")
	local rc=e:GetHandler():GetReasonCard()
	if rc then else rc=e:GetHandler():GetReasonEffect():GetHandler() end
	if rc then
		--Debug.Message("1")
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		e1:SetCode(EVENT_SPSUMMON_SUCCESS)
		e1:SetCountLimit(1)
		e1:SetLabelObject(rc)
		e1:SetOperation(cm.op2)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
		local e2=e1:Clone()
		e2:SetCode(EVENT_SUMMON_SUCCESS)
		Duel.RegisterEffect(e2,tp)
	end
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetOwner()
	local rc=e:GetLabelObject()
	--Debug.Message("2")
	if rc and rc==eg:GetFirst() and rc:GetSequence()==c:GetPreviousSequence() and rc:IsControler(tp) then
		--Debug.Message("3")
		Duel.RaiseEvent(c,EVENT_CUSTOM+m,nil,0,0,tp,0)
	end
	e:Reset()
end

function cm.tdfilter(c)
	return c:IsFaceup() and c:GetFlagEffect(m)==0
end
function cm.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(cm.tdfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,cm.tdfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function cm.tdop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		tc:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,0)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_BATTLE_DAMAGE)
		e1:SetCondition(cm.damcon)
		e1:SetValue(aux.ChangeBattleDamage(1,DOUBLE_DAMAGE))
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	end
end
function cm.damcon(e)
	return e:GetHandler():GetBattleTarget()~=nil
end







