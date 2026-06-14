--至高主宰·苍琼·风之君主
function c11182370.initial_effect(c)
	--synchro summon
	aux.AddSynchroMixProcedure(c,aux.Tuner(Card.IsSetCard,0x6454),nil,nil,nil,1,99)
	c:EnableReviveLimit()
	--special summon
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(11182370,0))
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetCondition(c11182370.sprcon)
	e0:SetTarget(c11182370.sprtg)
	e0:SetOperation(c11182370.sprop)
	e0:SetValue(SUMMON_TYPE_SYNCHRO)
	c:RegisterEffect(e0)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(11182370,1))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetHintTiming(TIMING_MAIN_END)
	e1:SetCondition(c11182370.con)
	e1:SetCost(c11182370.cost)
	e1:SetOperation(c11182370.activate)
	c:RegisterEffect(e1)
	--fusion summon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetHintTiming(0,TIMING_MAIN_END)
	e2:SetCountLimit(1,11182370)
	e2:SetCondition(c11182370.atcon)
	e2:SetOperation(c11182370.atop)
	c:RegisterEffect(e2)
	--immune effect
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetValue(c11182370.immunefilter)
	c:RegisterEffect(e3)
	--cannot be target
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE)
	e7:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e7:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
	e7:SetRange(LOCATION_MZONE)
	e7:SetValue(aux.imval1)
	c:RegisterEffect(e7)
	local e8=e7:Clone()
	e8:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e8:SetValue(aux.tgoval)
	c:RegisterEffect(e8)
end
function c11182370.sprfilter(c)
	return c:IsLocation(LOCATION_MZONE) and c:IsFaceup()
		or c:IsType(0x6) and c:IsLocation(0xe) and c:IsSetCard(0x6454)
end
function c11182370.getnumber(c)
	if c:IsLevelAbove(1) then
		return c:GetLevel()
	elseif c:IsRankAbove(1) then
		return c:GetRank()
	elseif c:IsLinkAbove(1) then
		return c:GetLink()
	elseif c:IsType(0x6) then
		return 3
	end
end
function c11182370.tuner(c)
	return c:IsSetCard(0x6454) and c:IsType(0x6+TYPE_XYZ+TYPE_LINK+TYPE_TUNER)
end
function c11182370.fselect(g,tp)
	return Duel.GetMZoneCount(tp,g)>0 and g:GetSum(c11182370.getnumber)==7
		and g:IsExists(c11182370.tuner,1,nil)
end
function c11182370.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local rg=Duel.GetMatchingGroup(c11182370.sprfilter,tp,0xe,0,nil)
	return rg:CheckSubGroup(c11182370.fselect,2,5,tp)
end
function c11182370.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=e:GetLabelObject()
	Duel.SendtoGrave(g,REASON_SPSUMMON+REASON_SYNCHRO)
	g:DeleteGroup()
end
function c11182370.sprtg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local rg=Duel.GetMatchingGroup(c11182370.sprfilter,tp,0xe,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
	local sg=rg:SelectSubGroup(tp,c11182370.fselect,true,2,5,tp)
	if sg then
		sg:KeepAlive()
		e:SetLabelObject(sg)
		return true
	else return false end
end
function c11182370.immunefilter(e,te)
	return te:IsActiveType(TYPE_MONSTER)
		and (te:GetHandler():IsAttribute(ATTRIBUTE_WIND) or te:GetHandler():IsType(TYPE_SYNCHRO))
end
function c11182370.atcon(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetHandler():GetMaterialCount()
	return Duel.IsMainPhase() and ct>1
end
function c11182370.tdfilter(c)
	return c:IsFaceupEx() and c:IsType(0x6) and c:IsAbleToDeck()
end
function c11182370.atop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ch=Duel.GetCurrentChain()
	local ck=false
	if ch>1 then
		local code=Duel.GetChainInfo(ch-1,CHAININFO_TRIGGERING_CODE)
		if code==11182315 then ck=true end
	end
	local b1=c:IsRelateToChain() and c:IsFaceup()
	local b2=Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,0,0xc,3,nil) and ck
	local b3=Duel.IsExistingMatchingCard(c11182370.tdfilter,tp,0x30,0x30,1,nil) and ck
	local op=aux.SelectFromOptions(tp,{b1,aux.Stringid(11182370,2)},{b2,aux.Stringid(11182370,3)},{b3,aux.Stringid(11182370,4)})
	if op==1 then
		local ct=c:GetMaterialCount()
		if ct>1 then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_EXTRA_ATTACK)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
			e1:SetValue(ct-1)
			c:RegisterEffect(e1)
			--direct attack
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_DIRECT_ATTACK)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
			c:RegisterEffect(e2)
		end
	elseif op==2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local g=Duel.SelectMatchingCard(tp,c11182370.tdfilter,tp,0,0xc,3,3,nil)
		if #g>0 then
			Duel.HintSelection(g)
			Duel.SendtoDeck(g,nil,2,0x40)
		end
	elseif op==3 then
		local g=Duel.GetMatchingGroup(c11182370.tdfilter,tp,0x30,0x30,nil)
		if #g>0 then
			Duel.SendtoDeck(g,nil,2,0x40)
		end
	end
end
function c11182370.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsAbleToEnterBP()
end
function c11182370.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToRemoveAsCost() end
	if Duel.Remove(c,0,REASON_COST+REASON_TEMPORARY)~=0 and c:GetOriginalCode()==id then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetReset(RESET_PHASE+PHASE_END)
		e1:SetLabelObject(c)
		e1:SetCountLimit(1)
		e1:SetOperation(c11182370.retop)
		Duel.RegisterEffect(e1,tp)
	end
end
function c11182370.retop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ReturnToField(e:GetLabelObject())
end
function c11182370.activate(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SKIP_BP)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,1)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end