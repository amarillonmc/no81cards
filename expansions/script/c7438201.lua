--背反之料理人 总厨
local m=7438201
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
	--[[--get effect
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,3))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_XMATERIAL+EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1)
	e2:SetCost(cm.descost)
	e2:SetTarget(cm.destg)
	e2:SetOperation(cm.desop)
	c:RegisterEffect(e2)]]
	--get effect
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCondition(cm.effcon)
	e2:SetOperation(cm.effop)
	c:RegisterEffect(e2)
	--[[if not cm.global_check then
		cm.global_check=true
		local ge0=Effect.CreateEffect(c)
		ge0:SetType(EFFECT_TYPE_FIELD)
		ge0:SetCode(EFFECT_ACTIVATE_COST)
		ge0:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
		ge0:SetTargetRange(1,1)
		ge0:SetTarget(cm.actarget)
		ge0:SetOperation(cm.costop)
		Duel.RegisterEffect(ge0,0)
		cm.global_trigger_effect=Effect.CreateEffect(c)
	end]]
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
function cm.thfilter(c)
	return cm.Crooked_Cook(c) and c:IsAbleToHand() and c:IsType(TYPE_MONSTER) and not c:IsCode(m)
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
		and c:IsPreviousLocation(LOCATION_OVERLAY) and re:GetHandler() and re:GetHandler():IsAttribute(ATTRIBUTE_FIRE)-- and cm.global_trigger_effect:GetLabelObject()==re
end
function cm.effop(e,tp,eg,ep,ev,re,r,rp)
	if re and re:GetHandler() then
		local c=e:GetHandler()
		local rc=re:GetHandler()
		Duel.Hint(HINT_CARD,0,m)
		Duel.HintSelection(Group.FromCards(rc))
		--[[local esetcountlimit=Effect.SetCountLimit
		cm.global_count=0
		cm.global_code=0
		Effect.SetCountLimit=function(effect,count,code)
			Debug.Message("123")
			cm.global_count=count
			cm.global_code=code
			return esetcountlimit(effect,count,code)
		end
		--effect
		local e1=re:Clone()
		Debug.Message(cm.global_count)
		Debug.Message(cm.global_code)
		Effect.SetCountLimit=esetcountlimit
		e1:SetCountLimit(cm.global_count,cm.global_code)]]
		--e1:SetOwner(c)
		--e1:SetCountLimit(1)
		--[[local e1=cm.global_copy_effect:Clone()
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		rc:RegisterEffect(e1)]]
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
				if cm.COUNT_CODE_table[1]==0 then cm.COUNT_CODE_table[1]=1 --Debug.Message("01") 
				end
				--Debug.Message("0")
				--Debug.Message("cm.COUNT_CODE_table2")
				--Debug.Message(#cm.COUNT_CODE_table)
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
				--Debug.Message("11")
				if cm.COUNT_CODE_table[1]==1 then
				--Debug.Message("1")
					local ct=2
					cm.COUNT_CODE_table[1]=59
					while ct<=#cm.COUNT_CODE_table do
						cregister(card,cm.COUNT_CODE_table[ct],flag)
						ct=ct+1
				--Debug.Message("2")
					end
					return
				end
				--Debug.Message("cm.COUNT_CODE_table")
				--Debug.Message(#cm.COUNT_CODE_table)
				return cregister(card,effect,flag)
			end
			if effect and cm.COUNT_CODE_table[1] and cm.COUNT_CODE_table[1]==59 then
				--Debug.Message("3")
				return cregister(card,effect,flag)
			end
			return 
		end
		local cid=rc:CopyEffect(rc:GetOriginalCodeRule(),RESET_EVENT+RESETS_STANDARD)
		Card.RegisterEffect=cregister
		Effect.SetCountLimit=esetcountlimit
		if cm.COUNT_CODE_table[1] and cm.COUNT_CODE_table[1]==59 then
			cm.COUNT_CODE_table[1]=rc
			--Debug.Message("cm.COUNT_CODE_table")
			--Debug.Message(#cm.COUNT_CODE_table)
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
	--[[local COUNT_CODE_table={e:GetLabelObject()}
		Debug.Message("COUNT_CODE_table")
		Debug.Message(#COUNT_CODE_table)
	local boolean=false
	local ct=2
	while ct<=#COUNT_CODE_table do
		Debug.Message("COUNT_CODE_table")
		Debug.Message(#COUNT_CODE_table)
		Debug.Message(ct)
		if te==COUNT_CODE_table[ct] then boolean=true end
		ct=ct+1
	end
		Debug.Message("0")]]
	return tc:GetFlagEffect(m+tc:GetFieldID()+te:GetFieldID())>0
end
function cm.costchk(e,te_or_c,tp)
		--Debug.Message("1")
	local COUNT_CODE_table={e:GetLabelObject()}
	local tc=COUNT_CODE_table[1]
		--Debug.Message("2")
	return Duel.GetFlagEffect(tp,m+tc:GetFieldID())<=0
end
function cm.costop(e,tp,eg,ep,ev,re,r,rp)
	local COUNT_CODE_table={e:GetLabelObject()}
	local tc=COUNT_CODE_table[1]
	return Duel.RegisterFlagEffect(tp,m+tc:GetFieldID(),RESET_PHASE+PHASE_END,0,0,1)
end
--[[function cm.actarget(e,te,tp)
	e:SetLabelObject(te)
	return te:IsActivated() and te:IsActiveType(TYPE_XYZ) and te:GetHandler() and te:GetHandler():IsAttribute(ATTRIBUTE_FIRE)
end
function cm.costop(e,tp,eg,ep,ev,re,r,rp)
	Debug.Message("123")
	local te=e:GetLabelObject()
	local tc=te:GetHandler()
	cm.global_trigger_effect:SetLabelObject(te)
	cm.global_copy_effect=te:Clone()
end]]
--[[function cm.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function cm.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_ONFIELD,0,1,e:GetHandler()) end
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,0,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,0,aux.ExceptThisCard(e))
	Duel.Destroy(g,REASON_EFFECT)
end]]
