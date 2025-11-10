local m=15006127
local cm=_G["c"..m]
cm.name="『神秘』的谜梦-长夜月"
function cm.initial_effect(c)
	c:SetSPSummonOnce(m)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkAttribute,ATTRIBUTE_DARK),3,3)
	c:EnableReviveLimit()
	--cannot link material
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
	e0:SetValue(1)
	c:RegisterEffect(e0)
	--DiscardHand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_HANDES)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(cm.diccon)
	e1:SetCost(cm.diccost)
	e1:SetTarget(cm.dictg)
	e1:SetOperation(cm.dicop)
	c:RegisterEffect(e1)
	--disable
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCategory(CATEGORY_TOKEN+CATEGORY_DISABLE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,m)
	e2:SetCondition(cm.tkcon)
	e2:SetTarget(cm.tktg)
	e2:SetOperation(cm.tkop)
	c:RegisterEffect(e2)
	--SpecialSummon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(m,2))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_REMOVE)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCondition(cm.dkcon)
	e4:SetTarget(cm.dktg)
	e4:SetOperation(cm.dkop)
	c:RegisterEffect(e4)
end
function cm.diccon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function cm.diccost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetDecktopGroup(tp,7)
	if chk==0 then return g:FilterCount(Card.IsAbleToRemoveAsCost,nil,POS_FACEDOWN)==7 end
	Duel.DisableShuffleCheck()
	Duel.Remove(g,POS_FACEDOWN,REASON_COST)
end
function cm.dictg(e,tp,eg,ep,ev,re,r,rp,chk)
	local p=Duel.GetTurnPlayer()
	if chk==0 then return Duel.GetFieldGroupCount(p,LOCATION_HAND,0)>0 end
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,p,1)
end
function cm.dicop(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetTurnPlayer()
	local d=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	local g=Duel.GetFieldGroup(p,LOCATION_HAND,0)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,p,HINTMSG_DISCARD)
		local sg=g:Select(p,1,1,nil)
		Duel.SendtoGrave(sg,REASON_EFFECT+REASON_DISCARD)
	end
end
function cm.sfilter(c)
	return c:IsCode(15006130) and c:IsFaceup()
end
function cm.tkcon(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(cm.sfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function cm.tktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and aux.NegateMonsterFilter(chkc) and chkc~=c end
	if chk==0 then return Duel.IsExistingTarget(aux.NegateMonsterFilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,c) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,15006130,nil,TYPES_TOKEN_MONSTER,2000,2000,7,RACE_PSYCHO,ATTRIBUTE_WATER) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,aux.NegateMonsterFilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,c)
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function cm.tkop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,15006130,nil,TYPES_TOKEN_MONSTER,2000,2000,7,RACE_PSYCHO,ATTRIBUTE_WATER) then
		local token=Duel.CreateToken(tp,15006130)
		if Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP) then
			local tc=Duel.GetFirstTarget()
			if tc:IsRelateToEffect(e) and tc:IsFaceup() then
				token:SetCardTarget(tc)
				tc:CreateRelation(token,RESET_EVENT+RESETS_STANDARD)
				--local e1=Effect.CreateEffect(token)
				--e1:SetType(EFFECT_TYPE_SINGLE)
				--e1:SetCode(EFFECT_DISABLE)
				--e1:SetCondition(cm.rcon)
				--e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				--tc:RegisterEffect(e1)
				--if tc:IsType(TYPE_TRAPMONSTER) then
				--	local e2=e1:Clone()
				--	e2:SetCode(EFFECT_DISABLE_TRAPMONSTER)
				--	tc:RegisterEffect(e2)
				--end
				Duel.NegateRelatedChain(tc,RESET_TURN_SET)
				local e3=Effect.CreateEffect(token)
				e3:SetType(EFFECT_TYPE_SINGLE)
				e3:SetCode(EFFECT_DISABLE)
				e3:SetCondition(cm.rcon)
				e3:SetReset(RESET_EVENT+RESETS_STANDARD)
				tc:RegisterEffect(e3)
				local e4=Effect.CreateEffect(token)
				e4:SetType(EFFECT_TYPE_SINGLE)
				e4:SetCode(EFFECT_DISABLE_EFFECT)
				e4:SetValue(RESET_TURN_SET)
				e4:SetCondition(cm.rcon)
				e4:SetReset(RESET_EVENT+RESETS_STANDARD)
				tc:RegisterEffect(e4)
				if tc:IsType(TYPE_TRAPMONSTER) then
					local e5=Effect.CreateEffect(token)
					e5:SetType(EFFECT_TYPE_SINGLE)
					e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
					e5:SetCode(EFFECT_DISABLE_TRAPMONSTER)
					e5:SetCondition(cm.rcon)
					e5:SetReset(RESET_EVENT+RESETS_STANDARD)
					tc:RegisterEffect(e5)
				end
				local e6=Effect.CreateEffect(e:GetHandler())
				e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
				e6:SetCode(EVENT_ADJUST)
				e6:SetRange(LOCATION_MZONE)
				e6:SetCondition(cm.tokendescon)
				e6:SetOperation(cm.tokendesop)
				e6:SetLabelObject(tc)
				e6:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
				token:RegisterEffect(e6,true)
			end
			Duel.SpecialSummonComplete()
		end
	end
end
function cm.rcon(e)
	return e:GetOwner():IsHasCardTarget(e:GetHandler())
end
function cm.tokendescon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetLabelObject():IsRelateToCard(e:GetHandler())
end
function cm.tokendesop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Destroy(e:GetHandler(),REASON_RULE)
end
function cm.dkfilter(c)
	return c:IsFacedown()
end
function cm.dkcon(e,tp,eg,ep,ev,re,r,rp)
	return not eg:IsContains(e:GetHandler()) and eg:IsExists(cm.dkfilter,1,nil)
end
function cm.dktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function cm.dkop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP)
	end
end