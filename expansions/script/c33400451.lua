--天使-绝灭天使 日轮
function c33400451.initial_effect(c)
  c:SetUniqueOnField(1,0,c33400451.uqfilter,LOCATION_ONFIELD)
	--destory
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e0:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e0:SetRange(LOCATION_SZONE)
	e0:SetCondition(c33400451.atkcon)
	e0:SetOperation(c33400451.atkop)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(33400451,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_BATTLE_DESTROYING)
	e1:SetCountLimit(1,33400451)
	e1:SetRange(LOCATION_SZONE)
	e1:SetLabelObject(e0)
	e1:SetCondition(c33400451.descon)  
	e1:SetOperation(c33400451.desop)
	c:RegisterEffect(e1)
	   --change code
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(33400451,1))
	e3:SetCategory(CATEGORY_EQUIP)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_SZONE)
	e3:SetHintTiming(0,TIMING_END_PHASE+TIMINGS_CHECK_MONSTER)
	e3:SetCountLimit(1,33400450)
	e3:SetTarget(c33400451.changetg)
	e3:SetOperation(c33400451.changeop)
	c:RegisterEffect(e3)
	 --back
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e9:SetCode(EVENT_ADJUST)
	e9:SetRange(LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_HAND+LOCATION_EXTRA)
	e9:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_SET_AVAILABLE)
	e9:SetCondition(c33400451.backon)
	e9:SetOperation(c33400451.backop)
	c:RegisterEffect(e9)
end
function c33400451.uqfilter(c) 
		return c:IsSetCard(0x5343)
end
function c33400451.atkcon(e,tp,eg,ep,ev,re,r,rp)
   return  e:GetHandler():GetEquipTarget():GetBattleTarget()~=nil
end
function c33400451.atkop(e,tp,eg,ep,ev,re,r,rp)
	local ec=e:GetHandler():GetEquipTarget()
	local tc=ec:GetBattleTarget()   
		e:SetLabel(tc:GetSequence())  
end
function c33400451.descon(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():GetEquipTarget() then return  end 
	local ec=eg:GetFirst()
	local bc=ec:GetBattleTarget()
	return e:GetHandler():GetEquipTarget()==eg:GetFirst() and ec:IsControler(tp)
		 and bc:IsReason(REASON_BATTLE)
end
function c33400451.desfilter2(c,s,tp)
	local seq=c:GetSequence()
	return seq<5 and math.abs(seq-s)==1 and c:IsControler(1-tp)
end
function c33400451.desop(e,tp,eg,ep,ev,re,r,rp)
		local seq=e:GetLabelObject():GetLabel()
		local dg=Group.CreateGroup()	  
		if seq<5 then dg=Duel.GetMatchingGroup(c33400451.desfilter2,tp,0,LOCATION_MZONE,nil,seq,tp) end
		if  dg:GetCount()>0 then
			 if Duel.Destroy(dg,REASON_EFFECT)==0 then
				 Duel.Damage(1-tp,1000,REASON_EFFECT)
			 end		   
		end
end

function c33400451.changetg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	 if chkc then return true end
  if chk==0 then return true end
	 if e:GetHandler():IsLocation(LOCATION_SZONE) then  e:GetHandler():CreateEffectRelation(e) end   
	if chk==0 then return (33400450 or 33400452 or 33400453 or 33400454)  and 33400451==c:GetOriginalCode()  and Duel.IsExistingTarget(c33400451.eqfilter2,tp,LOCATION_MZONE,0,1,nil)  end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c33400451.changeop(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() or c:IsImmuneToEffect(e) then return end
	local tcode
	local tg=Duel.SelectOption(tp,aux.Stringid(33400451,2),aux.Stringid(33400451,3),aux.Stringid(33400451,4),aux.Stringid(33400451,5)) 
	if tg==0 then 
	 tcode=33400450
	end 
	if tg==1 then 
	 tcode=33400452 
	end
	if tg==2 then  
	 tcode=33400453
	end 
	if tg==3 then 
	 tcode=33400454
	end
	c:SetEntityCode(tcode,true)
	c:ReplaceEffect(tcode,0,0)  
	 Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	 local tg=Duel.SelectMatchingCard(tp,c33400451.eqfilter2,tp,LOCATION_MZONE,0,1,1,nil)
	local tc=tg:GetFirst()  
		Duel.Equip(tp,c,tc)  
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(c33400451.eqlimit)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e1)		  
end
function c33400451.eqfilter2(c)
	return c:IsFaceup() and c:IsSetCard(0x5342) 
end
function c33400451.eqlimit(e,c)
	return c:GetControler()==e:GetHandlerPlayer() and c:IsSetCard(0x5342) 
end

function c33400451.backon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return 33400450 and c:GetOriginalCode()==33400451
end
function c33400451.backop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	c:SetEntityCode(33400450)
	Duel.ConfirmCards(tp,Group.FromCards(c))
	Duel.ConfirmCards(1-tp,Group.FromCards(c))
	c:ReplaceEffect(tcode,0,0)
end