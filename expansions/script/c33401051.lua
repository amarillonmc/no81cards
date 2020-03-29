--天使-灼烂歼鬼-炮
local m=33401051
local cm=_G["c"..m]
function cm.initial_effect(c)
	  c:SetUniqueOnField(1,0,m)  
 --destroy 
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,0))
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_SZONE)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e3:SetCountLimit(1,m+10000)
	e3:SetTarget(cm.destg)
	e3:SetOperation(cm.desop)
	c:RegisterEffect(e3)
--change code
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(m,2))
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetCountLimit(1,m+20000)
	e4:SetTarget(cm.changetg)
	e4:SetOperation(cm.changeop) 
	c:RegisterEffect(e4)
  --back
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e9:SetCode(EVENT_ADJUST)
	e9:SetRange(LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_HAND+LOCATION_EXTRA)
	e9:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_SET_AVAILABLE)
	e9:SetCondition(cm.backon)
	e9:SetOperation(cm.backop)
	c:RegisterEffect(e9)
end
function cm.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x9341) and c:IsType(TYPE_FUSION)
end
function cm.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc) 
	if chkc then return  chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and cm.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(cm.filter,tp,LOCATION_MZONE,0,1,nil) end 
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,cm.filter,tp,LOCATION_MZONE,0,1,1,nil) 
end
function cm.filter2(c)
	return c:IsFaceup() and c:IsSetCard(0x5344) and c:IsType(TYPE_FIELD) and c:IsType(TYPE_SPELL)
end
function cm.desfilter2(c,s,tp)
	local seq=c:GetSequence()
	return seq<5 and math.abs(seq-s)<=1 and c:IsControler(1-tp)
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()   
	 if tc:IsRelateToEffect(e) then
		local tg1=tc:GetColumnGroup():Filter(Card.IsControler,nil,1-tp)
		local dm1=Duel.Destroy(tg1,REASON_EFFECT)
		if dm1~=0 then 
		Duel.Damage(1-tp,500*dm1,REASON_EFFECT)
		Duel.Damage(tp,500*dm1,REASON_EFFECT)	 
		end
		if Duel.IsExistingMatchingCard(cm.filter2,tp,LOCATION_FZONE,0,1,nil) then			
			if Duel.SelectYesNo(tp,aux.Stringid(m,1)) then 
			   local seq=tc:GetSequence()
			   local  dg=Duel.GetMatchingGroup(cm.desfilter2,tp,0,LOCATION_ONFIELD,nil,seq,tp)
				if  dg:GetCount()>0 then
					 local ct=Duel.Destroy(dg,REASON_EFFECT)
					 if ct~=0 then
						  Duel.Damage(1-tp,500*ct,REASON_EFFECT)
						  Duel.Damage(tp,500*ct,REASON_EFFECT)  
					 end		   
				end
			end
		end
	end
end

function cm.changetg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return 33401050 and 33401051==c:GetOriginalCode() end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function cm.changeop(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() or c:IsImmuneToEffect(e) then return end
	c:SetEntityCode(33401050,true)
	c:ReplaceEffect(33401050,0,0)
end

function cm.backon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return 33401050 and c:GetOriginalCode()==33401051
end
function cm.backop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	c:SetEntityCode(33401050)
	Duel.ConfirmCards(tp,Group.FromCards(c))
	Duel.ConfirmCards(1-tp,Group.FromCards(c))
	c:ReplaceEffect(33401050,0,0)
end