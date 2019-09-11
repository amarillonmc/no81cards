--荒碑主
local m=14000388
local cm=_G["c"..m]
cm.named_with_Gravalond=1
function cm.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcCodeRep(c,14000380,3,true,true)
	--change name
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_CHANGE_CODE)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetValue(14000380)
	c:RegisterEffect(e1)
	--immune
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetTargetRange(LOCATION_GRAVE,0)
	e2:SetTarget(cm.etg)
	e2:SetValue(cm.efilter)
	c:RegisterEffect(e2)
	--in the end phase
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,0))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(cm.con)
	e3:SetTarget(cm.tg)
	e3:SetOperation(cm.op)
	c:RegisterEffect(e3)
end
function cm.Grava(c)
	local m=_G["c"..c:GetCode()]
	return m and (m.named_with_Gravalond or c:IsCode(14000380))
end
function cm.etg(e,c)
	return c:IsCode(14000380)
end
function cm.efilter(e,re)
	return re:GetOwnerPlayer()~=e:GetHandlerPlayer()
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function cm.spfilter(c,e,tp)
	return c:IsCode(14000380) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)==0 or not c:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc then
		Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPTION)
		sel=Duel.SelectOption(tp,aux.Stringid(m,1),aux.Stringid(m,2),aux.Stringid(m,3))+1
		if sel==1 then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetRange(LOCATION_MZONE)
			e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
			e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e1:SetCondition(cm.defcon)
			e1:SetTarget(cm.splimit)
			e1:SetTargetRange(1,1)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			tc:RegisterEffect(e1,true)
			tc:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,1))
		elseif sel==2 then
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_FIELD)
			e2:SetCode(EFFECT_CANNOT_SUMMON)
			e2:SetRange(LOCATION_MZONE)
			e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e2:SetTargetRange(1,1)
			e2:SetCondition(cm.defcon)
			e2:SetReset(RESET_EVENT+0x1fe0000)
			tc:RegisterEffect(e2)
			tc:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,2))
		elseif sel==3 then
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_FIELD)
			e3:SetCode(EFFECT_CANNOT_TO_HAND)
			e3:SetRange(LOCATION_MZONE)
			e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e3:SetTargetRange(1,1)
			e3:SetTarget(aux.TargetBoolFunction(Card.IsLocation,LOCATION_DECK))
			e3:SetCondition(cm.defcon)
			e3:SetReset(RESET_EVENT+0x1fe0000)
			tc:RegisterEffect(e3)
			tc:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,3))
		end
		if not tc:IsType(TYPE_EFFECT) then
			local e4=Effect.CreateEffect(c)
			e4:SetType(EFFECT_TYPE_SINGLE)
			e4:SetCode(EFFECT_ADD_TYPE)
			e4:SetValue(TYPE_EFFECT)
			e4:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e4,true)
		end
		Duel.SpecialSummonComplete()
	end
end
function cm.defcon(e)
	return e:GetHandler():IsDefensePos()
end
function cm.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsCode(14000380)
end