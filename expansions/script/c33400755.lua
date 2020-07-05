--七罪 魔女的谜团
local m=33400755
local cm=_G["c"..m]
function cm.initial_effect(c)
   --Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_POSITION+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
 --destroy
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(m,0))
	e5:SetCategory(CATEGORY_DESTROY)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_ATTACK_ANNOUNCE)
	e5:SetRange(LOCATION_SZONE)
	e5:SetCondition(cm.atkcon)
	e5:SetOperation(cm.atkop)
	c:RegisterEffect(e5)
end
function cm.filter(c)
	return c:GetSequence()<5 and not c:IsType(TYPE_TOKEN+TYPE_LINK) and c:IsSetCard(0x3342)
end
function cm.spfilter(c,e,tp)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and Duel.IsPlayerCanSpecialSummonMonster(tp,c:GetCode(),nil,0x11,0,0,0,0,0,POS_FACEDOWN) and c:IsSetCard(0x340,0x341)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_MZONE,0,1,nil)
		and not Duel.IsPlayerAffectedByEffect(tp,59822133)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>1
		and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_DECK,0,2,nil,e,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_DECK)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
local c=e:GetHandler()
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<2 then return end
	local g=Duel.GetMatchingGroup(cm.spfilter,tp,LOCATION_DECK,0,nil,e,tp)
	if g:GetCount()<2 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local tc=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_MZONE,0,1,1,nil):GetFirst()
	if not tc or tc:IsImmuneToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=g:Select(tp,2,2,nil)
	if tc:IsFaceup() then
		if tc:IsHasEffect(EFFECT_DEVINE_LIGHT) then Duel.ChangePosition(tc,POS_FACEUP_DEFENSE)
		else
			Duel.ChangePosition(tc,POS_FACEDOWN_DEFENSE)
			tc:ClearEffectRelation()
		end
	end
	local tg=sg:GetFirst()
	local fid=e:GetHandler():GetFieldID()
	while tg do
		local e1=Effect.CreateEffect(tg)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_TYPE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(TYPE_NORMAL+TYPE_MONSTER)
		e1:SetReset(RESET_EVENT+0x47c0000)
		tg:RegisterEffect(e1,true)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_REMOVE_RACE)
		e2:SetValue(RACE_ALL)
		tg:RegisterEffect(e2,true)
		local e3=e1:Clone()
		e3:SetCode(EFFECT_REMOVE_ATTRIBUTE)
		e3:SetValue(0xff)
		tg:RegisterEffect(e3,true)
		local e4=e1:Clone()
		e4:SetCode(EFFECT_SET_BASE_ATTACK)
		e4:SetValue(0)
		tg:RegisterEffect(e4,true)
		local e5=e1:Clone()
		e5:SetCode(EFFECT_SET_BASE_DEFENSE)
		e5:SetValue(0)
		tg:RegisterEffect(e5,true)
	  --cannot release
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCode(EFFECT_UNRELEASABLE_SUM)
	e6:SetValue(1)
	c:RegisterEffect(e6)
	local e7=e6:Clone()
	e7:SetCode(EFFECT_UNRELEASABLE_NONSUM)
	c:RegisterEffect(e7)
	local e8=e7:Clone()
	e8:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	e8:SetValue(1)
	c:RegisterEffect(e8)
	local e9=e8:Clone()
	e9:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	c:RegisterEffect(e9)
 --cannot be link material
	local e10=Effect.CreateEffect(c)
	e10:SetType(EFFECT_TYPE_SINGLE)
	e10:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e10:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
	e10:SetValue(1)
	c:RegisterEffect(e10)
		tg:RegisterFlagEffect(m,RESET_EVENT+0x47c0000+RESET_PHASE+PHASE_END,0,1,fid)
		tg:SetStatus(STATUS_NO_LEVEL,true)
		tg=sg:GetNext()
	end
	Duel.SpecialSummon(sg,0,tp,tp,true,false,POS_FACEDOWN_DEFENSE)
	Duel.ConfirmCards(1-tp,sg)
	sg:AddCard(tc)
	Duel.ShuffleSetCard(sg)
	sg:RemoveCard(tc)
	sg:KeepAlive()
	local de=Effect.CreateEffect(e:GetHandler())
	de:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	de:SetCode(EVENT_PHASE+PHASE_END)
	de:SetReset(RESET_PHASE+PHASE_END)
	de:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	de:SetCountLimit(1)
	de:SetLabel(fid)
	de:SetLabelObject(sg)
	de:SetOperation(cm.desop)
	Duel.RegisterEffect(de,tp)
end
function cm.desfilter(c,fid)
	return c:GetFlagEffectLabel(m)==fid
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	local fid=e:GetLabel()
	local tg=g:Filter(cm.desfilter,nil,fid)
	g:DeleteGroup()
	Duel.Destroy(tg,REASON_EFFECT)
	local tg2=tg:Filter(cm.desfilter,nil,fid)
	Duel.SendtoGrave(tg2,REASON_EFFECT)
end

function cm.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	if not d or a:GetControler()==d:GetControler() or not Duel.IsExistingMatchingCard(Card.IsFacedown,tp,LOCATION_ONFIELD,0,1,nil) then return end
	return a:GetCode()~=a:GetOriginalCode() or a:IsFacedown() or d:GetCode()~=d:GetOriginalCode() or d:IsFacedown() 
end
function cm.atkop(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
 if not d or a:GetControler()==d:GetControler() or not Duel.IsExistingMatchingCard(Card.IsFacedown,tp,LOCATION_ONFIELD,0,1,nil) then return end
local tc1=a
local tc2=d
  if a:GetControler()==tp then 
  tc1=d
  tc2=a
  end 
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CODE)
	local ac=Duel.AnnounceCard(1-tp)
	 Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,1))
	local cg=Duel.SelectMatchingCard(1-tp,Card.IsFacedown,tp,LOCATION_ONFIELD,0,1,1,nil)
	local cc=cg:GetFirst()
	Duel.ConfirmCards(tp,cc)
	Duel.ConfirmCards(1-tp,cc)
	if cc:GetCode()==ac then
	 Duel.SendtoGrave(tc2,REASON_EFFECT)
	else  Duel.SendtoGrave(tc1,REASON_EFFECT)
	end
end











