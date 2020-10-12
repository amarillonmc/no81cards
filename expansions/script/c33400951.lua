--天使-破军歌姬
local m=33400951
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:SetUniqueOnField(1,0,m)
   --Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.operation)  
	c:RegisterEffect(e1)
 --
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(cm.con)
	e2:SetTarget(cm.sptg1)
	e2:SetOperation(cm.spop1)
	c:RegisterEffect(e2)
end
function cm.filter(c)
	return c:IsSetCard(0x5340) and c:IsType(TYPE_CONTINUOUS) and not c:IsCode(m) and c:IsAbleToGrave()
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_DECK+LOCATION_ONFIELD,0,1,nil) end
	if  Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
	end
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
if  not Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_DECK+LOCATION_ONFIELD,0,1,nil) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_DECK+LOCATION_ONFIELD,0,1,1,nil)
	local tc=g:GetFirst()
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and tc and Duel.SendtoGrave(tc,POS_FACEUP,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_GRAVE)   then
		local code=tc:GetCode()
		c:CopyEffect(code,RESET_EVENT+RESETS_STANDARD,1)
		local fid=c:GetFieldID()
		c:RegisterFlagEffect(code,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,fid,aux.Stringid(code,0))   
	end
end

function cm.cfilter(c,tp)
	return  c:IsPreviousLocation(LOCATION_HAND) and c:GetPreviousControler()==tp
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	return  eg:IsExists(cm.cfilter,1,nil,tp) 
end
function cm.sptg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_DECK+LOCATION_ONFIELD,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK+LOCATION_ONFIELD)
end
function cm.spop1(e,tp,eg,ep,ev,re,r,rp)
if  not Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_DECK+LOCATION_ONFIELD,0,1,nil) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_DECK+LOCATION_ONFIELD,0,1,1,nil)
	local tc=g:GetFirst()
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and tc and Duel.SendtoGrave(tc,POS_FACEUP,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_GRAVE)   then
		local code=tc:GetCode()
		if c:GetFlagEffect(code)==0 then 
		c:CopyEffect(code,RESET_EVENT+RESETS_STANDARD,1)
		local fid=c:GetFieldID()
		c:RegisterFlagEffect(code,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,fid,aux.Stringid(code,0))   
		end
	end
end


