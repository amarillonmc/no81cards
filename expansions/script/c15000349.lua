local m=15000349
local cm=_G["c"..m]
cm.name="逆卷之影 空洞骑士"
function cm.initial_effect(c)
	c:EnableReviveLimit()
	--Link Summon
	aux.AddLinkProcedure(c,cm.mfilter,1,1)
	aux.AddCodeList(c,15000351)
	--code
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e0:SetCode(EFFECT_CHANGE_CODE)
	e0:SetRange(LOCATION_MZONE+LOCATION_GRAVE)
	e0:SetValue(15000351)
	c:RegisterEffect(e0)
	--imm
	local e1=Effect.CreateEffect(c)  
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)  
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)  
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)  
	e1:SetCondition(cm.tncon)  
	e1:SetOperation(cm.tnop)  
	c:RegisterEffect(e1)  
	local e2=Effect.CreateEffect(c)  
	e2:SetType(EFFECT_TYPE_SINGLE)  
	e2:SetCode(EFFECT_MATERIAL_CHECK)  
	e2:SetValue(cm.valcheck)  
	e2:SetLabelObject(e1)  
	c:RegisterEffect(e2)
	--rebirth
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCondition(cm.rbcon)
	e3:SetTarget(cm.rbtg)
	e3:SetOperation(cm.rbop)
	c:RegisterEffect(e3)
	if not KDlobal then
		KDlobal={}
		KDlobal["Effects"]={}
	end
	KDlobal["Effects"]["c15000349"]=e3
end
function cm.mfilter(c)
	return c:IsAttribute(ATTRIBUTE_FIRE) and not c:IsOriginalCodeRule(15000349)
end
function cm.valcheck(e,c)  
	local flag=0  
	local g=c:GetMaterial()  
	if g:GetCount()>0 and g:GetFirst():IsCode(15000351) then  
		flag=flag|2  
	end  
	e:GetLabelObject():SetLabel(flag)  
end   
function cm.tncon(e,tp,eg,ep,ev,re,r,rp)  
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK) and e:GetLabel()>0  
end  
function cm.tnop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler()   
	if e:GetLabel()&2==2 then  
	--immune
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	c:RegisterEffect(e2)
	c:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,0))  
	end  
end
function cm.rbcon(e,tp,eg,ep,ev,re,r,rp)
	local tp=e:GetHandler():GetControler()
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_MZONE) and c:IsSummonType(SUMMON_TYPE_LINK) and c:GetPreviousControler()==tp and ((rp==1-tp) or (aux.IsCodeListed(re:GetHandler(),15000351) and (re:GetHandler():IsType(TYPE_SPELL) or re:GetHandler():IsType(TYPE_TRAP)) and c:IsReason(REASON_EFFECT)))
end
function cm.rbtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local tp=e:GetHandler():GetControler()
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetMZoneCount(tp)~=0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function cm.rbop(e,tp,eg,ep,ev,re,r,rp)
	local tp=e:GetHandler():GetControler()
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.GetMZoneCount(tp)~=0 then
	if not Duel.IsPlayerCanSpecialSummonMonster(tp,15000350,0,0x4011,1000,1000,1,RACE_INSECT,ATTRIBUTE_FIRE) then return end
		local tc=Duel.CreateToken(tp,15000350)
		Debug.Message("反抗烈光吧，空洞骑士！于梦扉彼侧，终结巢的执念吧！")
		Duel.SpecialSummon(tc,0,tp,tp,true,true,POS_FACEUP)
		Debug.Message("从此，不再有梦......")
		--base attack
		local e0=Effect.CreateEffect(tc)
		e0:SetType(EFFECT_TYPE_SINGLE)
		e0:SetCode(EFFECT_SET_BASE_ATTACK)
		e0:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e0:SetRange(LOCATION_MZONE)
		e0:SetReset(RESET_EVENT+RESETS_STANDARD)
		e0:SetValue(cm.atkval)
		tc:RegisterEffect(e0)
		local e1=Effect.Clone(e0)
		e1:SetCode(EFFECT_SET_BASE_DEFENSE)
		tc:RegisterEffect(e1)
		--code
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e2:SetCode(EFFECT_CHANGE_CODE)
		e2:SetRange(LOCATION_MZONE)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		e2:SetValue(15000351)
		tc:RegisterEffect(e2)
		aux.AddCodeList(tc,15000351)
	end
end
function cm.atkval(e,c)
	return Duel.GetMatchingGroupCount(Card.IsCode,c:GetControler(),LOCATION_GRAVE,0,nil,15000351)*1000
end