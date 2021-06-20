--萨尔贡·术士干员-卡涅利安
function c79029475.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_EARTH),10,2,c79029475.ovfilter,aux.Stringid(79029475,0),99)
	c:EnableReviveLimit()
	--cannot atk
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_ATTACK)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCondition(c79029475.cncon)
	c:RegisterEffect(e1)  
	--immune
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetCondition(c79029475.cncon)
	e2:SetValue(c79029475.efilter)
	c:RegisterEffect(e2)
	--xxx
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DAMAGE+CATEGORY_DISABLE)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,79029475)
	e3:SetCost(c79029475.xxcost)
	e3:SetTarget(c79029475.xxtg)
	e3:SetOperation(c79029475.xxop)
	c:RegisterEffect(e3)
	--xyz
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_RECOVER)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,19029475)
	e4:SetTarget(c79029475.xyztg)
	e4:SetOperation(c79029475.xyzop)
	c:RegisterEffect(e4)
end
function c79029475.ovfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xa900) and c:IsLevel(10) and c:IsType(TYPE_SYNCHRO)
end
function c79029475.cncon(e)
	return e:GetHandler():GetFlagEffect(79029475)==0
end
function c79029475.efilter(e,te)
	return te:GetOwner():GetControler()~=e:GetOwner():GetControler()
end
function c79029475.xxcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	local x=e:GetHandler():GetOverlayCount()
	local d=e:GetHandler():RemoveOverlayCard(tp,x,x,REASON_COST)
	e:SetLabel(d)
end
function c79029475.xxtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local d=e:GetLabel()
	if chk==0 then return true end
	if d==1 then 
	Debug.Message("全员，按计划行动！")
	elseif d==2 then 
	Debug.Message("优雅，礼貌，那是贵族的做法。不是我的。")
	elseif d==3 then 
	Debug.Message("你喜欢文雅点的战斗方式，还是直接点的？")
	elseif d==4 then 
	Debug.Message("日安，各位。......让我们省略掉麻烦的步骤，直接开始吧。")
	end
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029475,d+2))
	if d>=3 then 
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,500)
	end
end
function c79029475.xfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_SPELLCASTER) and c:IsAttribute(ATTRIBUTE_DARK)
end
function c79029475.xxop(e,tp,eg,ep,ev,re,r,rp)
	local d=e:GetLabel()
	local c=e:GetHandler()
	if d>=1 then 
	--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(d*1000)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e1)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_ATTACK_ALL)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetValue(1)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	e1:SetCondition(c79029475.atkcon)
	e1:SetOwnerPlayer(tp)
	c:RegisterEffect(e1)
	c:RegisterFlagEffect(79029475,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(79029475,1))
	end
	if d>=2 then
	local g=Duel.GetMatchingGroup(aux.disfilter1,tp,0,LOCATION_ONFIELD,nil)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
		if tc:IsType(TYPE_TRAPMONSTER) then
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
			e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e3)
		end
		tc=g:GetNext()
	end 
	end
	if d>=3 then 
	Duel.Damage(1-tp,2000,REASON_EFFECT)
	end
	if d>=4 then 
		local g=Duel.GetMatchingGroup(c79029475.xfilter,tp,LOCATION_MZONE,0,nil)
		local tc=g:GetFirst()
		while tc do
			local e4=Effect.CreateEffect(c)
			e4:SetDescription(aux.Stringid(79029475,2))
			e4:SetType(EFFECT_TYPE_SINGLE)
			e4:SetCode(EFFECT_IMMUNE_EFFECT)
			e4:SetProperty(EFFECT_FLAG_CLIENT_HINT)
			e4:SetValue(c79029475.efilter2)
			e4:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			e4:SetOwnerPlayer(tp)
			tc:RegisterEffect(e4)
			local e4=Effect.CreateEffect(c)
			e4:SetType(EFFECT_TYPE_SINGLE)
			e4:SetCode(EFFECT_PIERCE)
			e4:SetValue(DOUBLE_DAMAGE)
			e4:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e4)
			tc=g:GetNext()
		end
	 end	
end
function c79029475.atkcon(e)
	return e:GetHandlerPlayer()==e:GetOwnerPlayer()
end
function c79029475.efilter2(e,re)
	return e:GetOwnerPlayer()~=re:GetOwnerPlayer()
end
function c79029475.ckfil(c)
	return c:IsPreviousLocation(LOCATION_ONFIELD) 
end
function c79029475.xyztg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(c79029475.ckfil,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,eg:FilterCount(c79029475.ckfil,nil)*1000)
end
function c79029475.xyzop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=eg:Filter(c79029475.ckfil,nil)
	Debug.Message("放心，我会把所有人都好好带回来的。")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029475,7))
	Duel.Overlay(c,g)
	Duel.BreakEffect()
	Duel.Recover(tp,g:GetCount()*1000,REASON_EFFECT)
end





