--镜野七罪 隐形的魔女
local m=33400710
local cm=_G["c"..m]
function cm.initial_effect(c)
 --fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,cm.matfilter1,3,true)
	   --indes
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(cm.indcon)
	e1:SetOperation(cm.indop)
	c:RegisterEffect(e1)  
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_MATERIAL_CHECK)
	e0:SetValue(cm.valcheck)
	e0:SetLabelObject(e1)
	c:RegisterEffect(e0)  
  --
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetCategory(CATEGORY_DISABLE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(cm.rpcon)
	e2:SetTarget(cm.reptg)
	e2:SetOperation(cm.repop)
	c:RegisterEffect(e2)
  --copy
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_IGNITION)
	e6:SetDescription(aux.Stringid(m,2))
	e6:SetRange(LOCATION_MZONE)
	e6:SetCountLimit(1,m)
	e6:SetTarget(cm.cptg)
	e6:SetOperation(cm.cpop)
	c:RegisterEffect(e6)
--
	local e7=Effect.CreateEffect(c)   
	e7:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e7:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e7:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e7:SetCode(EVENT_TO_GRAVE)
	e7:SetCountLimit(1,m+10000)
	e7:SetTarget(cm.rectg)
	e7:SetOperation(cm.recop)
	c:RegisterEffect(e7)
end
function cm.matfilter1(c)
	return  c:IsSetCard(0x3342) or c:GetCode()~=c:GetOriginalCode()
end

function cm.matval(c)
	if c:GetCode()~=c:GetOriginalCode() then return 1 end
	return 0
end
function cm.valcheck(e,c)
	local val=c:GetMaterial():GetSum(cm.matval)
	e:GetLabelObject():SetLabel(val)
end

function cm.indcon(e,tp,eg,ep,ev,re,r,rp)
   return  e:GetLabel()>0
end
function cm.indop(e,tp,eg,ep,ev,re,r,rp)
	  local c=e:GetHandler()
	local ss=e:GetLabel()+e:GetHandler():GetFlagEffect(33400707)	
	c:RegisterFlagEffect(33400707,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,0,0,aux.Stringid(m,4))
	if ss>1 then 
	for i=2,ss do 
	 c:RegisterFlagEffect(33400707,RESET_EVENT+RESETS_STANDARD,0,0,0)
	end
	end
end

function cm.rpcon(e,tp,eg,ep,ev,re,r,rp)  
	return   e:GetHandler():GetFlagEffect(33400707)>0
end
function cm.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
   if chkc then return chkc:IsOnField() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
end
function cm.repop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
	 local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_CHANGE_CODE)
		e1:SetValue(m)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1) 
		if (( not tc:IsDisabled()) or tc:IsType(TYPE_TRAPMONSTER)) and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
		if tc:IsType(TYPE_TRAPMONSTER) then
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
			e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e3)
		end
		end  
	end
end

function cm.cpfilter(c)
	return c:IsSetCard(0x3342) and c:IsLevelBelow(8) and not c:IsCode(m) 
end
function cm.cptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.cpfilter,tp,LOCATION_EXTRA+LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) end
end
function cm.cpop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local cg=Duel.SelectMatchingCard(tp,cm.cpfilter,tp,LOCATION_EXTRA+LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)
	if cg:GetCount()==0 then return end
	Duel.ConfirmCards(1-tp,cg)
	local code=cg:GetFirst():GetOriginalCode()
	local c=e:GetHandler()
	if not c:IsOnField() or c:IsFacedown() then return end  
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,2)
		e1:SetCode(EFFECT_CHANGE_CODE)
		e1:SetValue(code)
		c:RegisterEffect(e1)
		c:CopyEffect(code,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,2)
end

function cm.cfilter1(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsSetCard(0x3342) and not c:IsCode(m)
end
function cm.rectg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
   if chkc then return false end
	if chk==0 then
		return Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
		and Duel.IsExistingTarget(cm.cfilter1,tp,LOCATION_GRAVE,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0	   
	end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,3))
	local g1=Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	e:SetLabelObject(g1:GetFirst())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g2=Duel.SelectTarget(tp,cm.cfilter1,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g2,1,0,0)
end
function cm.recop(e,tp,eg,ep,ev,re,r,rp)
local c=e:GetHandler()
	local tc=e:GetLabelObject()
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local lc=tg:GetFirst()
	if lc==tc then lc=tg:GetNext() end
	local cd=lc:GetCode()
	if lc:IsRelateToEffect(e) and lc:IsControler(tp)and  Duel.SpecialSummon(lc,0,tp,tp,false,false,POS_FACEUP)~=0 and  tc:IsFaceup() and tc:IsRelateToEffect(e)  then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_CHANGE_CODE)
		e1:SetValue(cd)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1) 
	end
end




