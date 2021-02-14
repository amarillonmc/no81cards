--忍者超兽 伽玛斯
local m=25000138
local cm=_G["c"..m]
function cm.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	 --ct
	local e0=Effect.CreateEffect(c)
	e0:SetCategory(CATEGORY_DESTROY)
	e0:SetType(EFFECT_TYPE_IGNITION)
	e0:SetCountLimit(1,m)
	e0:SetRange(LOCATION_PZONE)
	e0:SetTarget(cm.pentg)
	e0:SetOperation(cm.penop)
	c:RegisterEffect(e0)
 --draw
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(cm.drcon)
	e1:SetTarget(cm.drtg)
	e1:SetOperation(cm.drop)
	c:RegisterEffect(e1)
	if not cm.global_check then
		cm.global_check=true
		cm[0]=0
		cm[1]=0
		cm[2]=0
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_DESTROYED)
		ge1:SetOperation(cm.checkop)
		Duel.RegisterEffect(ge1,0)
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		ge2:SetOperation(cm.clearop)
		Duel.RegisterEffect(ge2,0)
	end
 --sc fusion
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,3))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON+CATEGORY_TOEXTRA)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_HAND)
	e3:SetCountLimit(1,m+10000)
	e3:SetCost(cm.spcost3)
	e3:SetTarget(cm.sptg3)
	e3:SetOperation(cm.spop3)
	c:RegisterEffect(e3)
end
function cm.pcfilter(c,code)
	return  c:IsSetCard(0xaf6) and c:IsType(TYPE_PENDULUM) and c:GetCode()~=code and c:IsFaceup() and not c:IsForbidden()
end
function cm.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
	local b2=Duel.IsExistingMatchingCard(cm.pcfilter,tp,LOCATION_EXTRA,0,1,nil,e:GetHandler():GetCode())
	if chk==0 then return   b2 end  
  Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,0,0)
end
function cm.desfilter(c)
	return c:IsFaceup()  and c:IsType(TYPE_PENDULUM)
end
function cm.penop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end   
	local b2=Duel.IsExistingMatchingCard(cm.pcfilter,tp,LOCATION_EXTRA,0,1,nil,e:GetHandler():GetCode())
	if  b2  then
	local dg
	  if (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)) then
	  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	  dg=Duel.SelectMatchingCard(tp,cm.desfilter,tp,LOCATION_ONFIELD,0,1,1,nil)
	  else 
	  dg=Duel.SelectMatchingCard(tp,cm.desfilter,tp,LOCATION_PZONE,0,1,1,nil)
	  end
	 if  Duel.Destroy(dg,REASON_EFFECT)==0 then return  end
	end  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectMatchingCard(tp,cm.pcfilter,tp,LOCATION_EXTRA,0,1,1,nil,e:GetHandler():GetCode())
	if g:GetCount()>0 then
		Duel.MoveToField(g:GetFirst(),tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	end
end

function cm.checkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	while tc do
		if tc:IsSetCard(0xaf6) and tc:IsType(TYPE_PENDULUM) and tc:GetPreviousControler()==tp then
			if tc:GetPreviousLocation()==LOCATION_HAND then  cm[0]=1 end
			if tc:GetPreviousLocation()==LOCATION_SZONE then  cm[1]=1 end
			if tc:GetPreviousLocation()==LOCATION_MZONE then  cm[2]=1 end
		end
		tc=eg:GetNext()
	end
end
function cm.clearop(e,tp,eg,ep,ev,re,r,rp)
	cm[0]=0
	cm[1]=0
	cm[2]=0
end
function cm.drcon(e,tp,eg,ep,ev,re,r,rp)
	local ct=cm[0]+cm[1]+cm[2]
	return ct>0 and Duel.GetTurnPlayer()==tp
end
function cm.drtg(e,tp,eg,ep,ev,re,r,rp,chk) 
	local ct=cm[0]+cm[1]+cm[2]
	if chk==0 then return Duel.IsPlayerCanDraw(tp,ct) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,ct)
end
function cm.drop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local ct=cm[0]+cm[1]+cm[2]
	Duel.Draw(tp,ct,REASON_EFFECT)
end

function cm.costfilter(c,e,tp,mg)
	if not (c:IsType(TYPE_PENDULUM) and c:IsType(TYPE_FUSION) 
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and  Duel.GetLocationCountFromEx(tp,tp,mg,c)>0) then return false end
	return c:GetLeftScale()>0  and  mg:CheckSubGroup(cm.fselect,2,c:GetLeftScale(),c:GetLeftScale(),tp)
end
function cm.fselect(g,sc,tp)
	local mg=g:Clone()
	if Duel.GetMZoneCount(tp,mg)>0 then
			Duel.SetSelectedCard(g)
			return g:CheckWithSumGreater(Card.GetLeftScale,sc)
	else return false end
end
function cm.spcost3(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return not e:GetHandler():IsPublic() end
end
function cm.tefilter(c)
	return  c:IsType(TYPE_PENDULUM) and c:GetLeftScale()>0 and c:IsAbleToExtra()
end
function cm.sptg3(e,tp,eg,ep,ev,re,r,rp,chk)
	local rg=Duel.GetMatchingGroup(cm.tefilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,nil)   
	if chk==0 then return Duel.IsExistingMatchingCard(cm.costfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,rg)  and aux.MustMaterialCheck(nil,tp,EFFECT_MUST_BE_FMATERIAL) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function cm.spop3(e,tp,eg,ep,ev,re,r,rp)
	local mg=Duel.GetMatchingGroup(cm.tefilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,nil)   
	if not (Duel.IsExistingMatchingCard(cm.costfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg)  and aux.MustMaterialCheck(nil,tp,EFFECT_MUST_BE_FMATERIAL)) then return end  
	 Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g1=Duel.SelectMatchingCard(tp,cm.costfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,mg)
	local tc=g1:GetFirst()
	if tc then
	local g=mg:SelectSubGroup(tp,cm.fselect,false,2,tc:GetLeftScale(),tc:GetLeftScale(),tp)
	if Duel.SendtoExtraP(g,nil,REASON_EFFECT)==g:GetCount() then	   
			tc:SetMaterial(nil)
			if Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)~=0 then
				tc:CompleteProcedure()
			end
	end
	end
end


