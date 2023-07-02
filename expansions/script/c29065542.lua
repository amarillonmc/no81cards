--方舟骑士-史尔特尔
c29065542.named_with_Arknight=1
function c29065542.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedureLevelFree(c,c29065542.mfilter,aux.TRUE,2,2)
	c:EnableReviveLimit()  
	--xyz 
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c29065542.cxyzcon)
	e1:SetOperation(c29065542.cxyzop)
	c:RegisterEffect(e1) 

end
function c29065542.mfilter(c,xyzc)
	local b1=(c:IsSetCard(0x87af) or (_G["c"..c:GetCode()] and  _G["c"..c:GetCode()].named_with_Arknight))
	local b2=c:IsXyzLevel(xyzc,5)
	local b3=c:IsXyzLevel(xyzc,6)
	return b1 and (b2 or b3)
end
function c29065542.ovfilter(c)
	return c:IsFaceup() and (c:IsSetCard(0x87af) or (_G["c"..c:GetCode()] and  _G["c"..c:GetCode()].named_with_Arknight)) 
end
function c29065542.xyzop(e,tp,chk)
	if chk==0 then return (Duel.IsCanRemoveCounter(tp,1,0,0x10ae,2,REASON_COST) or (Duel.GetFlagEffect(tp,29096814)==1 and Duel.IsCanRemoveCounter(tp,1,0,0x10ae,1,REASON_COST))) and Duel.GetFlagEffect(tp,29065542)==0 end
	if Duel.GetFlagEffect(tp,29096814)==1 then
	Duel.ResetFlagEffect(tp,29096814)
	Duel.RemoveCounter(tp,1,0,0x10ae,1,REASON_RULE)
	Duel.RegisterFlagEffect(tp,29065542,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
	else
	Duel.RemoveCounter(tp,1,0,0x10ae,2,REASON_RULE)
	Duel.RegisterFlagEffect(tp,29065542,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
	end
end
function c29065542.cxyzcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end
function c29065542.cxyzop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	Duel.Hint(HINT_CARD,0,29065542)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetValue(1)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_SET_ATTACK_FINAL) 
	e3:SetValue(c29065542.atkval)
	e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_CANNOT_DIRECT_ATTACK)
	e4:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e4) 
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EVENT_ADJUST) 
	e5:SetRange(LOCATION_MZONE) 
	e5:SetCondition(c29065542.dscon) 
	e5:SetOperation(c29065542.dsop) 
	e5:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e5) 
	local fid=e:GetHandler():GetFieldID()
	c:RegisterFlagEffect(29065542,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,fid,aux.Stringid(29065542,0))
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCountLimit(1)
	e1:SetLabel(fid)
	e1:SetLabelObject(c)
	e1:SetCondition(c29065542.retcon)
	e1:SetOperation(c29065542.retop)
	Duel.RegisterEffect(e1,tp)
end
function c29065542.atkval(e,c)
	return c:GetAttack()*3
end
function c29065542.retcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:GetFlagEffectLabel(29065542)~=e:GetLabel() then
		e:Reset()
		return false
	else return true end
end
function c29065542.retop(e,tp,eg,ep,ev,re,r,rp) 
	Duel.Hint(HINT_CARD,0,29065542)
	local tc=e:GetLabelObject()
	Duel.SendtoDeck(tc,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
end
function c29065542.damcon(e)
	return e:GetHandler():GetBattleTarget()~=nil
end
function c29065542.xdamcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetBattleTarget()~=nil
end
function c29065542.xdamop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ChangeBattleDamage(ep,ev*3)
end
function c29065542.dscon(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local cg=c:GetColumnGroup():Filter(Card.IsControler,nil,1-tp):Filter(Card.IsDestructable,nil)
	return cg:GetCount()>0 
end 
function c29065542.dsop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler()
	local cg=c:GetColumnGroup():Filter(Card.IsControler,nil,1-tp):Filter(Card.IsDestructable,nil)
	if cg:GetCount()>0 then 
	Duel.Hint(HINT_CARD,0,29065542) 
	Duel.Destroy(cg,REASON_EFFECT)
	end 
end  

