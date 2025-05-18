--人理星姬 原初空想
function c22023010.initial_effect(c)
	aux.AddCodeList(c,22021910)
	c:EnableReviveLimit()
	aux.AddFusionProcMix(c,false,true,c22023010.fusfilter1,c22023010.fusfilter2,c22023010.fusfilter3,c22023010.fusfilter4,c22023010.fusfilter5)
	aux.AddContactFusionProcedure(c,c22023010.cffilter,LOCATION_MZONE,LOCATION_MZONE,c22023010.sprop(c))
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c22023010.splimit)
	c:RegisterEffect(e1)
	--inactivatable
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_INACTIVATE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(c22023010.effectfilter)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_DISEFFECT)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(c22023010.effectfilter)
	c:RegisterEffect(e3)
	--Activate
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(22023010,0))
	e4:SetCategory(CATEGORY_DISABLE)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,22023010)
	e4:SetTarget(c22023010.target)
	e4:SetOperation(c22023010.operation)
	c:RegisterEffect(e4)
	--Activate ere
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(22023010,1))
	e5:SetCategory(CATEGORY_DISABLE)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e5:SetRange(LOCATION_GRAVE)
	e5:SetCondition(c22023010.erecon)
	e5:SetCost(c22023010.erecost)
	e5:SetCountLimit(1,22023010)
	e5:SetTarget(c22023010.target)
	e5:SetOperation(c22023010.operation)
	c:RegisterEffect(e5)
end
function c22023010.splimit(e,se,sp,st)
	return bit.band(st,SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION
end
function c22023010.fusfilter1(c)
	return c:IsFusionCode(22021910)
end
function c22023010.fusfilter2(c)
	return c:IsFusionType(TYPE_FUSION)
end
function c22023010.fusfilter3(c)
	return c:IsFusionType(TYPE_SYNCHRO)
end
function c22023010.fusfilter4(c)
	return c:IsFusionType(TYPE_XYZ)
end
function c22023010.fusfilter5(c)
	return c:IsFusionType(TYPE_LINK)
end
function c22023010.cfilter(c)
	return c:IsFaceup() and c:IsCode(22023000)
end
function c22023010.cffilter(c,fc)
	return c:IsReleasable() and (c:IsControler(fc:GetControler()) or c:IsFaceup()) and Duel.IsExistingMatchingCard(c22023010.cfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
end
function c22023010.sprop(c)
	return  function(g)
				Duel.Release(g,REASON_COST)
			end
end
function c22023010.effectfilter(e,ct)
	local p=e:GetHandler():GetControler()
	local te,tp,loc=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER,CHAININFO_TRIGGERING_LOCATION)
	return p==tp and te:GetHandler():IsSetCard(0xff1) and bit.band(loc,LOCATION_ONFIELD)~=0
end
function c22023010.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CARDTYPE)
	local types={1056,1063,1073,1076}
	local alist=Duel.GetFlagEffectLabel(tp,id)
	if not alist then
		Duel.SetTargetParam(types[Duel.SelectOption(tp,table.unpack(types))+1])
	else
		local options={}
		for i = 1, 4, 1 do
			if bit.extract(alist,i)==0 then
				table.insert(options,types[i])
			end
		end
		Duel.SetTargetParam(options[Duel.SelectOption(tp,table.unpack(options))+1])
	end
end
function c22023010.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local opt=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	local ct,p=0,0
	if opt==1056 then ct=TYPE_FUSION	p=1 end
	if opt==1063 then ct=TYPE_SYNCHRO   p=2 end
	if opt==1073 then ct=TYPE_XYZ	   p=3 end
	if opt==1076 then ct=TYPE_LINK	  p=4 end
	local alist=Duel.GetFlagEffectLabel(tp,id)
	if not alist then
		alist=1<<p
		Duel.RegisterFlagEffect(tp,id,RESET_PHASE+PHASE_END,0,1,alist)
	else
		alist=alist|(1<<p)
		Duel.SetFlagEffectLabel(tp,id,alist)
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetLabel(ct)
	e1:SetTargetRange(1,1)
	e1:SetTarget(c22023010.sumlimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_DISABLE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetTarget(c22023010.distg)
	e2:SetLabel(ct)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
end
function c22023010.sumlimit(e,c,sump,sumtype,sumpos,targetp)
	return c:GetOriginalType()&e:GetLabel()>0
end
function c22023010.distg(e,c)
	return c:IsType(e:GetLabel())
end
function c22023010.erecon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsPlayerAffectedByEffect(tp,22020980)
end
function c22023010.erecost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_CARD,0,22020980)
	Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))
end