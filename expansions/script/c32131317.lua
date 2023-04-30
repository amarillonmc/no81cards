--繁星的画家 格蕾修
function c32131317.initial_effect(c)
	aux.AddCodeList(c,32131316)
	aux.AddMaterialCodeList(c,32131316)
	--code
	local e0=Effect.CreateEffect(c)  
	e0:SetType(EFFECT_TYPE_SINGLE)  
	e0:SetCode(EFFECT_ADD_CODE) 
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE) 
	e0:SetRange(0xff) 
	e0:SetValue(32131316) 
	c:RegisterEffect(e0)
	--link summon
	aux.AddLinkProcedure(c,nil,2,99,c32131317.lcheck)
	c:EnableReviveLimit() 
	--copy 
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(32131317,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1)  
	e1:SetCondition(c32131317.copycon) 
	e1:SetCost(c32131317.copycost) 
	e1:SetTarget(c32131317.copytg)
	e1:SetOperation(c32131317.copyop)
	c:RegisterEffect(e1)  
	--indes
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(function(e,c)
	return c:GetMutualLinkedGroupCount()>0 end) 
	e2:SetValue(1)
	c:RegisterEffect(e2)
	--cannot target
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(function(e,c)
	return c:GetMutualLinkedGroupCount()>0 end) 
	e2:SetValue(1)
	c:RegisterEffect(e2)
end
c32131317.SetCard_HR_flame13=true 
c32131317.HR_Flame_CodeList=32131316 
function c32131317.lcheck(g)
	return g:IsExists(Card.IsLinkCode,1,nil,32131316) 
end 
function c32131317.ckfil(c) 
	return c:IsFaceup() and c.SetCard_HR_flame13   
end 
function c32131317.copycon(e,tp,eg,ep,ev,re,r,rp) 
	return Duel.IsExistingMatchingCard(c32131317.ckfil,tp,LOCATION_MZONE,0,1,e:GetHandler()) 
end 
function c32131317.copycost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetFlagEffect(41209827)==0 end
	e:GetHandler():RegisterFlagEffect(41209827,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
end
function c32131317.copyfilter(c)
	return c:IsType(TYPE_MONSTER) and c.SetCard_HR_flame13 and not c:IsType(TYPE_TOKEN) and (c:IsFaceup() or c:IsLocation(LOCATION_GRAVE))
end
function c32131317.copytg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler() 
	if chk==0 then return Duel.IsExistingTarget(c32131317.copyfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,LOCATION_MZONE+LOCATION_GRAVE,1,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c32131317.copyfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,LOCATION_MZONE+LOCATION_GRAVE,1,1,c)
end
function c32131317.copyop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc and c:IsRelateToEffect(e) and c:IsFaceup() and tc:IsRelateToEffect(e) and (tc:IsFaceup() or tc:IsLocation(LOCATION_GRAVE)) then
		local code=tc:GetOriginalCodeRule()
		local cid=0 
		if not tc:IsType(TYPE_TRAPMONSTER) then
			cid=c:CopyEffect(code,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,2) 
		end
		local e3=Effect.CreateEffect(c)
		e3:SetDescription(aux.Stringid(32131317,1))
		e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e3:SetCode(EVENT_PHASE+PHASE_END)
		e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		e3:SetCountLimit(1)  
		e3:SetRange(LOCATION_MZONE)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,2) 
		e3:SetLabel(cid,Duel.GetTurnCount())
		e3:SetOperation(c32131317.rstop)
		c:RegisterEffect(e3)
	end
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_PIERCE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
end
function c32131317.rstop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local cid,turn=e:GetLabel() 
	if Duel.GetTurnCount()~=turn then 
	if cid~=0 then
		c:ResetEffect(cid,RESET_COPY)
		c:ResetEffect(RESET_DISABLE,RESET_EVENT)
	end  
	Duel.HintSelection(Group.FromCards(c))
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription()) 
	end 
end





