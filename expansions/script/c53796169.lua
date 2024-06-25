if not require and dofile then function require(str) return dofile(str..".lua") end end
if not pcall(function() require("expansions/script/c53702500") end) then require("script/c53702500") end
local s,id,o=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,s.matfilter1,s.matfilter2,true)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE+CATEGORY_COIN)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTarget(s.destg)
	e1:SetOperation(s.desop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	local e4=e1:Clone()
	e4:SetCode(EVENT_MSET)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(id,1))
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_DESTROYED)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e5:SetCondition(s.spcon)
	e5:SetTarget(s.sptg)
	e5:SetOperation(s.spop)
	c:RegisterEffect(e5)
end
s.toss_coin=true
function s.matfilter1(c,fc)
	return c:IsFusionCode(87751584) and c:IsSummonType(SUMMON_TYPE_FUSION) and c:IsLocation(LOCATION_MZONE)
end
function s.matfilter2(c,fc)
	return c:IsFusionAttribute(ATTRIBUTE_DARK) and c:IsRace(RACE_MACHINE)
end
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_COIN,nil,0,tp,3)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,Duel.GetFieldGroup(0,LOCATION_ONFIELD,LOCATION_ONFIELD),0,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,0)
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local c1,c2,c3=Duel.TossCoin(tp,3)
	local ct=c1+c2+c3
	if Duel.GetFieldGroupCount(0,LOCATION_ONFIELD,LOCATION_ONFIELD)>=ct then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,ct,ct,nil)
		Duel.HintSelection(g)
		local ret1,ret2={},{}
		for tc in aux.Next(g) do
			local le1={tc:IsHasEffect(EFFECT_INDESTRUCTABLE_EFFECT)}
			local le2={tc:IsHasEffect(EFFECT_INDESTRUCTABLE)}
			local le3={tc:IsHasEffect(EFFECT_INDESTRUCTABLE_COUNT)}
			for _,v in pairs(le1) do
				local val=v:GetValue()
				if not val then val=aux.TRUE end
				if not SNNM.IsInTable(v,ret1) then
					table.insert(ret1,v)
					table.insert(ret2,val)
				end
				v:SetValue(s.chval(val,e))
			end
			for _,v in pairs(le2) do
				local val=v:GetValue()
				if not val then val=aux.TRUE end
				if not SNNM.IsInTable(v,ret1) then
					table.insert(ret1,v)
					table.insert(ret2,val)
				end
				v:SetValue(s.chval(val,e))
			end
			for _,v in pairs(le3) do
				local val=v:GetValue()
				if not val then val=aux.TRUE end
				if not SNNM.IsInTable(v,ret1) then
					table.insert(ret1,v)
					table.insert(ret2,val)
				end
				v:SetValue(s.chval(val,e))
			end
		end
		Duel.Destroy(g,REASON_EFFECT)
		for i=1,#ret1 do ret1[i]:SetValue(ret2[i]) end
	end
	if 3-ct>0 then Duel.Damage(1-tp,(3-ct)*500,REASON_EFFECT) end
end
function s.chval(_val,ce)
	return function(e,te,...)
				if te==ce then return false end
				return _val(e,te,...)
			end
end
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_MZONE) and c:IsSummonType(SUMMON_TYPE_FUSION)
end
function s.spfilter(c,e,tp)
	return c.toss_coin and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and s.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingTarget(s.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,s.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) or Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)==0 or not tc:IsLocation(LOCATION_MZONE) or tc:IsFacedown() then return end
	local cp={}
	local f=Card.RegisterEffect
	Card.RegisterEffect=function(tc,te,bool)
		if te:GetCategory()&CATEGORY_COIN~=0 and te:GetType()&EFFECT_TYPE_IGNITION~=0 and te:GetRange()&0x4~=0 then table.insert(cp,te:Clone()) end
		return f(tc,te,bool)
	end
	Duel.CreateToken(tp,tc:GetOriginalCode())
	for i,v in ipairs(cp) do
		local e1=v:Clone()
		e1:SetType(EFFECT_TYPE_QUICK_O)
		e1:SetCode(EVENT_FREE_CHAIN)
		e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
		local con=v:GetCondition()
		if not con then con=aux.TRUE end
		e1:SetCondition(s.recon(con))
		e1:SetReset(RESET_EVENT+0xfe0000)
		tc:RegisterEffect(e1,true)
	end
	Card.RegisterEffect=f
end
function s.recon(_con)
	return  function(e,tp,eg,ep,ev,re,r,rp)
				return Duel.GetTurnPlayer()~=tp and _con(e,tp,eg,ep,ev,re,r,rp)
			end
end
