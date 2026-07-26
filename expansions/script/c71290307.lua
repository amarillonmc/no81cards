-- 特里同君主 真红亚历山大
local cm,m,o=GetID()
function cm.initial_effect(c)
	--fusion material
	aux.AddFusionProcFun2(c,cm.mfilter1,cm.mfilter2,true)

	c:EnableReviveLimit()
	--level
	local e33=Effect.CreateEffect(c)
	e33:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e33:SetCode(EVENT_SPSUMMON_SUCCESS)
	e33:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e33:SetCountLimit(1)
	e33:SetCondition(cm.lvcon)
	e33:SetOperation(cm.lvop)
	c:RegisterEffect(e33)
	
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAIN_END)
	e1:SetRange(LOCATION_MZONE)
	e1:SetLabelObject(e33)
	e1:SetOperation(cm.bkop)
	c:RegisterEffect(e1)
	
	
end
function cm.mfilter1(c)
	return c:IsSetCard(0x9622) and not c:IsType(TYPE_FUSION)
end
function cm.mfilter2(c)
	return not c:IsSetCard(0x9622) and c:IsType(TYPE_EFFECT)
end
function cm.rmfil(c,lv)
	return c:IsType(TYPE_FUSION) and c:IsLevelBelow(lv-1) and c:IsAbleToRemove()
end
function cm.lvcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION) --and e:GetHandler():GetFlagEffect(m)~=0
end
function cm.ttlv(c)
	return c:GetOriginalLevel()
end
function cm.lvop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=c:GetMaterial()
	local xlv=g:GetSum(cm.ttlv)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CHANGE_LEVEL)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	e1:SetValue(xlv)
	c:RegisterEffect(e1)
	if Duel.IsExistingMatchingCard(cm.rmfil,tp,LOCATION_EXTRA,0,1,nil,xlv) and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
		local rg=Duel.GetMatchingGroup(cm.rmfil,tp,LOCATION_EXTRA,0,nil,xlv):Select(tp,1,1,nil)
		if rg and Duel.Remove(rg,POS_FACEUP,REASON_EFFECT) then
			local rmvg=Duel.GetOperatedGroup()
			e:SetLabelObject(rmvg)
			rmvg:KeepAlive()
			local code=rmvg:GetFirst():GetCode()
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD+RESET_DISABLE)
			e1:SetCode(EFFECT_CHANGE_CODE)
			e1:SetValue(code)
			c:RegisterEffect(e1)
			c:CopyEffect(code,RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD+RESET_DISABLE)
		end
	end
end

function cm.mgfilter(c,tp,sync)
	return c:IsControler(tp) and not c:IsFacedown()
		--and bit.band(c:GetReason(),0x80008)==0x80008 
		and c:GetReasonCard()==sync
		and c:IsAbleToHand()
end
function cm.bkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tp=e:GetHandlerPlayer()
	local bg=e:GetLabelObject():GetLabelObject()
	Duel.SendtoDeck(c,nil,2,REASON_EFFECT)
	local a=#Duel.GetOperatedGroup()
	Duel.SendtoDeck(bg,nil,2,REASON_EFFECT)
	local b=#Duel.GetOperatedGroup()
	local mg=e:GetHandler():GetMaterial()
	Debug.Message(a)
	Debug.Message(b)
	Debug.Message(#mg)
	if a~=0 and b~=0 and #mg~=0 and mg:FilterCount(aux.NecroValleyFilter(cm.mgfilter),nil,tp,e:GetHandler())==#mg and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
		Duel.BreakEffect()
		local mc=mg:Select(tp,1,1,nil)
		Duel.SendtoHand(mc,nil,REASON_EFFECT)
	end
end