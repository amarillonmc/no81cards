--莱茵生命·重装干员-塞雷娅
function c79029077.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddXyzProcedure(c,nil,12,3)
	--pendulum summon
	aux.EnablePendulumAttribute(c)   
	--atk up
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_MZONE)
	e1:SetOperation(c79029077.atkop)
	c:RegisterEffect(e1)
	--cannot target
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_ONFIELD)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetValue(aux.tgoval)
	c:RegisterEffect(e2)
	--Damage and Recover
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE+CATEGORY_DAMAGE+CATEGORY_RECOVER)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetCountLimit(1,79029077)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCost(c79029077.drcost)
	e5:SetTarget(c79029077.drtg)
	e5:SetOperation(c79029077.drop)
	c:RegisterEffect(e5)
	--indes
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e6:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
	e6:SetRange(LOCATION_ONFIELD)
	e6:SetTargetRange(LOCATION_ONFIELD,0)
	e6:SetValue(c79029077.indct)
	c:RegisterEffect(e6)
	--pendulum
	local e7=Effect.CreateEffect(c)
	e7:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e7:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e7:SetCode(EVENT_LEAVE_FIELD)
	e7:SetProperty(EFFECT_FLAG_DELAY)
	e7:SetTarget(c79029077.pentg)
	e7:SetOperation(c79029077.penop)
	c:RegisterEffect(e7)
	--double
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_FIELD)
	e8:SetCode(EFFECT_CHANGE_BATTLE_DAMAGE)
	e8:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e8:SetRange(LOCATION_PZONE)
	e8:SetTargetRange(0,1)
	e8:SetValue(DOUBLE_DAMAGE)
	c:RegisterEffect(e8)
	--spsummon
	local e9=Effect.CreateEffect(c)
	e9:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e9:SetType(EFFECT_TYPE_IGNITION)
	e9:SetCountLimit(1)
	e9:SetRange(LOCATION_PZONE)
	e9:SetTarget(c79029077.target2)
	e9:SetOperation(c79029077.operation2)
	c:RegisterEffect(e9)
end
function c79029077.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()  
	if Duel.GetFlagEffect(tp,79029077)==0 then 
	Duel.Hint(HINT_CARD,0,79029077)
	Debug.Message("前进。")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029077,0))   
	Duel.RegisterFlagEffect(tp,79029077,RESET_PHASE+PHASE_END,0,1) 
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(500)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e2)
end
function c79029077.drcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c79029077.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return (c:GetAttack()~=c:GetBaseAttack() or c:GetDefense()~=c:GetBaseDefense()) end 
	local atk=math.abs(c:GetAttack()-c:GetBaseAttack())
	local def=math.abs(c:GetDefense()-c:GetBaseDefense())
	local x=atk+def 
	Duel.SetTargetPlayer(tp)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,0,0,tp,x)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,0,0,1-tp,x)
end 
function c79029077.drop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local atk=math.abs(c:GetAttack()-c:GetBaseAttack())
	local def=math.abs(c:GetDefense()-c:GetBaseDefense())
	local x=atk+def 
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	if c:IsRelateToEffect(e) then 
	Debug.Message("压制他们。")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029077,1))  
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SET_ATTACK_FINAL)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c:GetBaseAttack())
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_SET_DEFENSE_FINAL)
	e2:SetValue(c:GetBaseDefense())
	c:RegisterEffect(e2)
	Duel.Recover(p,x,REASON_EFFECT)
	Duel.Damage(1-p,x,REASON_EFFECT)
	end
end
function c79029077.indct(e,re,r,rp)
	if bit.band(r,REASON_BATTLE+REASON_EFFECT)~=0 then
		return 1
	else return 0 end
end
function c79029077.penfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c79029077.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c79029077.penfilter,tp,LOCATION_PZONE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_PZONE)
end
function c79029077.penop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c79029077.penfilter,tp,LOCATION_PZONE,0,1,1,nil,e,tp)
	if g:GetCount()>0 and Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)>0 then
	Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	Debug.Message("不许放弃。")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029077,5))  
	end
end

function c79029077.icon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp or ep==tp
end
function c79029077.iop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetAttacker()
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_PRE_BATTLE_DAMAGE)
	e4:SetCondition(c79029077.icon)
	e4:SetOperation(c79029077.damop)
	e4:SetReset(RESET_PHASE+PHASE_DAMAGE)
	tc:RegisterEffect(e4)
end
function c79029077.damop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ChangeBattleDamage(1-tp,ev*2)
end
function c79029077.sfilter(c,e,tp)
	return c:IsSetCard(0x1907) and c:IsPosition(POS_FACEUP) and c:IsLocation(LOCATION_EXTRA) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP) and Duel.GetLocationCountFromEx(tp)>0 or (c:IsSetCard(0x1907) and c:IsLocation(LOCATION_HAND+LOCATION_GRAVE) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP) )
end
function c79029077.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c79029077.sfilter,tp,LOCATION_EXTRA+LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA+LOCATION_HAND+LOCATION_GRAVE)
end
function c79029077.operation2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c79029077.sfilter,tp,LOCATION_EXTRA+LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	if tc:IsCode(79029028) then 
	Debug.Message("你看到了我和赫默吵架？家常便饭而已......抱歉，给你和罗德岛带来了麻烦。")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029077,3))	  
	elseif tc:IsCode(79029078) then 
	Debug.Message("请你帮我转告伊芙利特，“无论今后发生什么，我都会保护你”......见面？不，我还没准备好去见她。")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029077,4))	  
	else
	Debug.Message("很快就会结束。")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029077,2))  
	end
end


