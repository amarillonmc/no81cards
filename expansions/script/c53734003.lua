local m=53734003
local cm=_G["c"..m]
cm.name="守青缀 羽山海己"
if not pcall(function() require("expansions/script/c53702500") end) then require("script/c53702500") end
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,m)
	e1:SetTarget(cm.sptg)
	e1:SetOperation(cm.spop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_MOVE)
	e3:SetCondition(cm.spcon)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(m,1))
	e4:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EVENT_REMOVE)
	e4:SetCountLimit(1,m+50)
	e4:SetTarget(cm.thtg)
	e4:SetOperation(cm.thop)
	c:RegisterEffect(e4)
	if not cm.Aozora_Check then
		cm.Aozora_Check=true
		cm[0]=Duel.RegisterEffect
		Duel.RegisterEffect=function(e,p)
			if e:GetCode()==EFFECT_DISABLE_FIELD then
				local pro,pro2=e:GetProperty()
				pro=pro|EFFECT_FLAG_PLAYER_TARGET
				e:SetProperty(pro,pro2)
				e:SetTargetRange(1,1)
			end
			cm[0](e,p)
		end
		cm[1]=Card.RegisterEffect
		Card.RegisterEffect=function(c,e,bool)
			if e:GetCode()==EFFECT_DISABLE_FIELD then
				local op,range,con=e:GetOperation(),0,0
				if e:GetRange() then range=e:GetRange() end
				if e:GetCondition() then con=e:GetCondition() end
				if op then
					local ex=Effect.CreateEffect(c)
					ex:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
					ex:SetCode(EVENT_ADJUST)
					ex:SetRange(range)
					ex:SetOperation(cm.exop)
					cm[1](c,ex)
					cm[ex]={op,range,con}
					e:SetOperation(nil)
				else
					local pro,pro2=e:GetProperty()
					pro=pro|EFFECT_FLAG_PLAYER_TARGET
					e:SetProperty(pro,pro2)
					e:SetTargetRange(1,1)
				end
			end
			cm[1](c,e,bool)
		end
	end
end
function cm.exop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:GetFlagEffect(m)>0 then return end
	c:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD+RESET_OVERLAY,0,0)
	local op,range,con=cm[e][1],cm[e][2],cm[e][3]
	local val=op(e,tp)
	if tp==1 then val=((val&0xffff)<<16)|((val>>16)&0xffff) end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_DISABLE_FIELD)
	if range~=0 then e1:SetRange(range) end
	if con~=0 then e1:SetCondition(con) end
	e1:SetValue(val)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_OVERLAY)
	c:RegisterEffect(e1)
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsLocation(LOCATION_MZONE) and c:IsPreviousLocation(LOCATION_REMOVED) and not c:IsReason(REASON_SPSUMMON)
end
function cm.filter(c,e,tp)
	return c:IsSetCard(0x3536) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 then Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP) end
end
function cm.thfilter(c)
	return c:IsSetCard(0x3536) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,c,1,0,0)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local hg=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if hg:GetCount()>0 and Duel.SendtoHand(hg,tp,REASON_EFFECT)>0 and hg:GetFirst():IsLocation(LOCATION_HAND) then
		Duel.ConfirmCards(1-tp,hg)
		local dis=1<<c:GetSequence()
		if Duel.Remove(c,0,REASON_EFFECT+REASON_TEMPORARY)>0 and c:IsLocation(LOCATION_REMOVED) then
			if SNNM.DisMZone(tp)&dis>0 then return end
			local zone=dis
			if tp==1 then dis=((dis&0xffff)<<16)|((dis>>16)&0xffff) end
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetCode(EFFECT_DISABLE_FIELD)
			e1:SetValue(dis)
			Duel.RegisterEffect(e1,tp)
			c:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD,0,0)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e2:SetCode(EVENT_ADJUST)
			e2:SetLabel(zone)
			e2:SetLabelObject(c)
			e2:SetCondition(cm.retcon)
			e2:SetOperation(cm.retop)
			Duel.RegisterEffect(e2,tp)
		end
	end
end
function cm.retcon(e,tp,eg,ep,ev,re,r,rp)
	local tc,dis=e:GetLabelObject(),e:GetLabel()
	if not tc or tc:GetFlagEffect(m)==0 then
		e:Reset()
		return false
	else return Duel.CheckLocation(tp,LOCATION_MZONE,math.log(dis,2)) end
end
function cm.retop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	Duel.ReturnToField(tc,tc:GetPreviousPosition(),e:GetLabel())
	e:Reset()
end
