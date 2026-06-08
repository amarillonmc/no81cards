--DEchoes #A1 - Sensation
local s,id,o=GetID()
if not DEchoes then
	DEchoes={}
	DEchoes.SET_ECHOES=0x463
	DEchoes.SET_DECHOES=0x3463
	DEchoes.SET_KERNEL=0x5463
	DEchoes.COUNTER_TECH=0x1462
	function DEchoes.IsEchoes(c)
		return c:IsSetCard(DEchoes.SET_ECHOES)
	end
	function DEchoes.IsDEchoes(c)
		return c:IsSetCard(DEchoes.SET_DECHOES)
	end
	function DEchoes.IsKernel(c)
		return c:IsSetCard(DEchoes.SET_KERNEL)
	end
	function DEchoes.IsDEchoesMonster(c)
		return c:IsSetCard(DEchoes.SET_DECHOES) and c:IsType(TYPE_MONSTER)
	end
	function DEchoes.IsKernelMonster(c)
		return c:IsSetCard(DEchoes.SET_KERNEL) and c:IsType(TYPE_MONSTER)
	end
	function DEchoes.FaceupDEchoes(c)
		return c:IsFaceup() and DEchoes.IsDEchoesMonster(c)
	end
	function DEchoes.FaceupEchoes(c)
		return c:IsFaceup() and DEchoes.IsEchoes(c) and c:IsType(TYPE_MONSTER)
	end
	function DEchoes.ExtraKernel(c)
		return DEchoes.IsKernelMonster(c) and c:IsDestructable()
	end
	function DEchoes.GraveKernel(c)
		return DEchoes.IsKernelMonster(c) and c:IsAbleToExtra()
	end
	function DEchoes.AddTechCounterPermit(c)
		c:EnableCounterPermit(DEchoes.COUNTER_TECH)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_COUNTER_PERMIT+DEchoes.COUNTER_TECH)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		c:RegisterEffect(e1)
	end
	function DEchoes.AddCode(c,code)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_ADD_SETCODE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(code)
		c:RegisterEffect(e1)
	end
	function DEchoes.KernelProcCondition(ct,extra)
		return function(e,c)
			if c==nil then return true end
			local tp=c:GetControler()
			if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return false end
			if extra and not extra(e,c,tp) then return false end
			local g=Duel.GetMatchingGroup(DEchoes.ExtraKernel,tp,LOCATION_EXTRA,0,nil)
			return g:GetClassCount(Card.GetCode)>=ct
		end
	end
	function DEchoes.KernelProcTarget(ct)
		return function(e,tp,eg,ep,ev,re,r,rp,chk,c)
			local g=Duel.GetMatchingGroup(DEchoes.ExtraKernel,tp,LOCATION_EXTRA,0,nil)
			if g:GetClassCount(Card.GetCode)<ct then return false end
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
			local sg=g:SelectSubGroup(tp,aux.dncheck,false,ct,ct)
			if sg then
				sg:KeepAlive()
				e:SetLabelObject(sg)
				return true
			end
			return false
		end
	end
	function DEchoes.KernelProcOperation(id)
		return function(e,tp,eg,ep,ev,re,r,rp,c)
			local g=e:GetLabelObject()
			if not g then return end
			Duel.Destroy(g,REASON_COST)
			g:DeleteGroup()
			Duel.RegisterFlagEffect(tp,id,RESET_PHASE+PHASE_END,0,1)
		end
	end
	function DEchoes.AddHandKernelProc(c,id,ct,extra)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
		e1:SetCode(EFFECT_SPSUMMON_PROC)
		e1:SetRange(LOCATION_HAND)
		e1:SetCondition(DEchoes.KernelProcCondition(ct,extra))
		e1:SetTarget(DEchoes.KernelProcTarget(ct))
		e1:SetOperation(DEchoes.KernelProcOperation(id))
		e1:SetValue(SUMMON_VALUE_SELF)
		c:RegisterEffect(e1)
	end
	function DEchoes.AddBattleTrigger(c,desc,cat,tg,op)
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(desc)
		e1:SetCategory(cat)
		e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
		e1:SetCode(EVENT_BATTLE_START)
		if tg then e1:SetTarget(tg) end
		if op then e1:SetOperation(op) end
		c:RegisterEffect(e1)
	end
	function DEchoes.KernelMaterial(race)
		return function(c,fc,sub,mg,sg)
			return c:IsRace(race) and c:IsFusionSetCard(DEchoes.SET_DECHOES)
		end
	end
	function DEchoes.AddKernelFusion(c,race)
		c:EnableReviveLimit()
		aux.AddFusionProcFunRep(c,DEchoes.KernelMaterial(race),2,true)
	end
	function DEchoes.GrantTarget(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
		if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and DEchoes.FaceupDEchoes(chkc) end
		if chk==0 then return Duel.IsExistingTarget(DEchoes.FaceupDEchoes,tp,LOCATION_MZONE,0,1,nil) end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
		Duel.SelectTarget(tp,DEchoes.FaceupDEchoes,tp,LOCATION_MZONE,0,1,1,nil)
	end
	function DEchoes.AddGrantTrigger(c,id,grant,desc_index)
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(id,desc_index or 0))
		e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
		e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
		e1:SetCode(EVENT_DESTROYED)
		e1:SetTarget(DEchoes.GrantTarget)
		e1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
			local tc=Duel.GetFirstTarget()
			if tc and tc:IsRelateToEffect(e) and tc:IsFaceup() then
				grant(e,tc)
			end
		end)
		c:RegisterEffect(e1)
	end
	function DEchoes.ReturnKernelFromGY(tp,minc,maxc,reason)
		local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(DEchoes.GraveKernel),tp,LOCATION_GRAVE,0,nil)
		if g:GetClassCount(Card.GetCode)<minc then return 0 end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local sg=g:SelectSubGroup(tp,aux.dncheck,false,minc,maxc)
		if not sg then return 0 end
		Duel.HintSelection(sg)
		return Duel.SendtoDeck(sg,nil,SEQ_DECKSHUFFLE,reason or REASON_EFFECT)
	end
	function DEchoes.DestroyExtraKernel(tp,minc,maxc)
		local g=Duel.GetMatchingGroup(DEchoes.ExtraKernel,tp,LOCATION_EXTRA,0,nil)
		if g:GetCount()<minc then return nil end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		return Duel.SelectMatchingCard(tp,DEchoes.ExtraKernel,tp,LOCATION_EXTRA,0,minc,maxc,nil)
	end
end
function s.initial_effect(c)
	DEchoes.AddTechCounterPermit(c)
	DEchoes.AddHandKernelProc(c,id,3)
	DEchoes.AddBattleTrigger(c,aux.Stringid(id,0),CATEGORY_TODECK+CATEGORY_DAMAGE+CATEGORY_RECOVER,s.tdtg,s.tdop)
end
function s.tdfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToDeck()
end
function s.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and s.tdfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(s.tdfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,s.tdfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,200)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,200)
end
function s.tdop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and Duel.SendtoDeck(tc,nil,SEQ_DECKTOP,REASON_EFFECT)>0 then
		Duel.Damage(1-tp,200,REASON_EFFECT)
		Duel.Recover(tp,200,REASON_EFFECT)
	end
end
