--背反之料理人 厨师长
local m=7438202
local cm=_G["c"..m]

cm.named_with_Crooked_Cook=1

function cm.Crooked_Cook(c)
	local m=_G["c"..c:GetCode()]
	return m and (m.named_with_Crooked_Cook or c:IsCode(82697249))
end

function cm.initial_effect(c)
	--Destroy and Special Summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DESTROY+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(TIMING_END_PHASE,TIMING_END_PHASE+TIMINGS_CHECK_MONSTER)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCountLimit(1,m)
	e1:SetTarget(cm.sptg)
	e1:SetOperation(cm.spop)
	c:RegisterEffect(e1)
	--get effect
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCondition(cm.effcon)
	e2:SetOperation(cm.effop)
	c:RegisterEffect(e2)
	
end
function cm.desfilter(c,tp)
	return c:IsFaceup() and cm.Crooked_Cook(c) and Duel.GetMZoneCount(tp,c)>0
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsOnField() and chkc:IsControler(tp) and cm.desfilter(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(cm.desfilter,tp,LOCATION_ONFIELD,0,1,nil,tp)
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,cm.desfilter,tp,LOCATION_ONFIELD,0,1,1,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function cm.cfilter(c,code)
	return c:IsCode(code) and (c:IsFaceup() or not c:IsOnField())
end
function cm.thfilter(c,tp)
	return cm.Crooked_Cook(c) and c:IsType(TYPE_QUICKPLAY) and c:IsAbleToHand()
		and not Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,1,nil,c:GetCode())
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)~=0 then
		local c=e:GetHandler()
		if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 then
			local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(cm.thfilter),tp,LOCATION_DECK,0,nil)
			if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
				Duel.BreakEffect()
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
				local sg=g:Select(tp,1,1,nil)
				Duel.SendtoHand(sg,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,sg)
			end
		end
	end
end
function cm.effcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsReason(REASON_COST) and re:IsActivated() and re:IsActiveType(TYPE_XYZ)
		and c:IsPreviousLocation(LOCATION_OVERLAY) and re:GetHandler() and re:GetHandler():IsAttribute(ATTRIBUTE_FIRE)
end
function cm.effop(e,tp,eg,ep,ev,re,r,rp)
	if re and re:GetHandler() then
		local c=e:GetHandler()
		local rc=re:GetHandler()
		Duel.Hint(HINT_CARD,0,m)
		Duel.HintSelection(Group.FromCards(rc))
		cm.COUNT_CODE_table={0}
		local description=re:GetDescription()
		local category=re:GetCategory()
		local condition=re:GetCondition()
		local cost=re:GetCost()
		local target=re:GetTarget()
		local operation=re:GetOperation()
		
		local esetcountlimit=Effect.SetCountLimit
		Effect.SetCountLimit=function(effect,count,code)
			if code and bit.band(code,EFFECT_COUNT_CODE_SINGLE)==EFFECT_COUNT_CODE_SINGLE then
				if cm.COUNT_CODE_table[1]==0 then cm.COUNT_CODE_table[1]=1
				end
				cm.COUNT_CODE_table[#cm.COUNT_CODE_table+1]=effect
				return esetcountlimit(effect,count,0)
			end
			return esetcountlimit(effect,count,code)
		end
		local cregister=Card.RegisterEffect
		Card.RegisterEffect=function(card,effect,flag)
			if effect
				and (not description or description==effect:GetDescription())
				and (not category or category==effect:GetCategory())
				and (not condition or condition==effect:GetCondition())
				and (not cost or cost==effect:GetCost())
				and (not target or target==effect:GetTarget())
				and (not operation or operation==effect:GetOperation()) then
				if cm.COUNT_CODE_table[1]==1 then
					local ct=2
					cm.COUNT_CODE_table[1]=59
					while ct<=#cm.COUNT_CODE_table do
						cregister(card,cm.COUNT_CODE_table[ct],flag)
						ct=ct+1
					end
					return
				end
				return cregister(card,effect,flag)
			end
			if effect and cm.COUNT_CODE_table[1] and cm.COUNT_CODE_table[1]==59 then
				return cregister(card,effect,flag)
			end
			return 
		end
		local cid=rc:CopyEffect(rc:GetOriginalCodeRule(),RESET_EVENT+RESETS_STANDARD)
		Card.RegisterEffect=cregister
		Effect.SetCountLimit=esetcountlimit
		if cm.COUNT_CODE_table[1] and cm.COUNT_CODE_table[1]==59 then
			cm.COUNT_CODE_table[1]=rc
			rc:RegisterFlagEffect(m+rc:GetFieldID(),RESET_EVENT+RESETS_STANDARD,0,0,1)
			local ct=2
			while ct<=#cm.COUNT_CODE_table do
				rc:RegisterFlagEffect(m+rc:GetFieldID()+cm.COUNT_CODE_table[ct]:GetFieldID(),RESET_EVENT+RESETS_STANDARD,0,0,1)
				ct=ct+1
			end
			local ge0=Effect.CreateEffect(c)
			ge0:SetType(EFFECT_TYPE_FIELD)
			ge0:SetCode(EFFECT_ACTIVATE_COST)
			ge0:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
			ge0:SetLabelObject(table.unpack(cm.COUNT_CODE_table))
			ge0:SetTargetRange(1,1)
			ge0:SetTarget(cm.actarget)
			ge0:SetCost(cm.costchk)
			ge0:SetOperation(cm.costop)
			Duel.RegisterEffect(ge0,0)
		end
	end
end
function cm.actarget(e,te,tp)
	local tc=te:GetHandler()
	if tc:GetFlagEffect(m+tc:GetFieldID())<=0 then return false end
	return tc:GetFlagEffect(m+tc:GetFieldID()+te:GetFieldID())>0
end
function cm.costchk(e,te_or_c,tp)
	local COUNT_CODE_table={e:GetLabelObject()}
	local tc=COUNT_CODE_table[1]
	return Duel.GetFlagEffect(tp,m+tc:GetFieldID())<=0
end
function cm.costop(e,tp,eg,ep,ev,re,r,rp)
	local COUNT_CODE_table={e:GetLabelObject()}
	local tc=COUNT_CODE_table[1]
	return Duel.RegisterFlagEffect(tp,m+tc:GetFieldID(),RESET_PHASE+PHASE_END,0,0,1)
end
