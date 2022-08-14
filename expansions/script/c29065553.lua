--方舟骑士-陈·游龙
c29065553.named_with_Arknight=1
function c29065553.initial_effect(c) 
	aux.AddCodeList(c,29065508) 
	c:EnableReviveLimit() 
	--add 
	local e1=Effect.CreateEffect(c) 
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS) 
	e1:SetCode(EVENT_CHAINING) 
	e1:SetRange(LOCATION_MZONE) 
	e1:SetCondition(c29065553.adcon) 
	e1:SetOperation(c29065553.adop) 
	c:RegisterEffect(e1)	
	--Destroy 
	local e2=Effect.CreateEffect(c) 
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS) 
	e2:SetCode(EVENT_CHAINING) 
	e2:SetRange(LOCATION_MZONE) 
	e2:SetCondition(c29065553.dscon) 
	e2:SetOperation(c29065553.dsop) 
	c:RegisterEffect(e2)	
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e0:SetCode(EVENT_SPSUMMON_SUCCESS)
	e0:SetCondition(c29065553.matcon)
	e0:SetOperation(c29065553.matop)
	c:RegisterEffect(e0)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_MATERIAL_CHECK)
	e5:SetValue(c29065553.valcheck)
	e5:SetLabelObject(e0)
	c:RegisterEffect(e5)
end
function c29065553.adcon(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	return c:GetFlagEffect(29065553)~=0 and c:IsCanAddCounter(0x10af,1) and rp==1-tp 
end 
function c29065553.adop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler() 
	c:AddCounter(0x10af,1) 
end 
function c29065553.dscon(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler()  
	return c:GetFlagEffect(29065553)~=0 and c:IsCanRemoveCounter(tp,0x10af,3,REASON_EFFECT) and rp==1-tp
end 
function c29065553.dsfil(c,s,p) 
	local seq=c:GetSequence()
	return s<5 and seq<5 and math.abs(seq-s)==1 and c:IsControler(p)
end
function c29065553.dsop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler()  
	local rc=re:GetHandler()
	Duel.Hint(HINT_CARD,0,29065553) 
	if not c:IsCanRemoveCounter(tp,0x10af,3,REASON_EFFECT) then return end 
	c:RemoveCounter(tp,0x10af,3,REASON_EFFECT)  
	local g=Group.CreateGroup()
	if rc:IsOnField() then 
	local seq=rc:GetSequence() 
	local p=rc:GetControler()
	g=Duel.GetMatchingGroup(c29065553.dsfil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,seq,p)  
	end 
	Duel.Destroy(rc,REASON_EFFECT)  
	if g:GetCount()>0 then  
	Duel.HintSelection(g)
	Duel.Destroy(g,REASON_EFFECT)
	end 
end 
function c29065553.matcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_RITUAL) and e:GetLabel()==1
end
function c29065553.matop(e,tp,eg,ep,ev,re,r,rp) 
	Duel.Hint(HINT_CARD,0,29065553) 
	e:GetHandler():RegisterFlagEffect(29065553,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(29065553,0))
end
function c29065553.valcheck(e,c)
	local mg=c:GetMaterial()
	if mg:IsExists(Card.IsCode,1,nil,29065508) then
		e:GetLabelObject():SetLabel(1)
	else
		e:GetLabelObject():SetLabel(0)
	end
end




