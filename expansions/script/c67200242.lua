--古风精 米尔沫
function c67200242.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	aux.AddCodeList(c,67200161)
	--equip
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(67200242,0))
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,67200242)
	e1:SetTarget(c67200242.eqtg)
	e1:SetOperation(c67200242.eqop)
	c:RegisterEffect(e1)
	--synchro custom  
	local e2=Effect.CreateEffect(c)  
	e2:SetType(EFFECT_TYPE_SINGLE)  
	e2:SetCode(EFFECT_SYNCHRO_MATERIAL_CUSTOM)  
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)   
	e2:SetTarget(c67200242.syntg)  
	e2:SetValue(1)  
	e2:SetOperation(c67200242.synop)  
	c:RegisterEffect(e2)
end
--
function c67200242.filter(c)
	return c:IsFaceup() and c:IsCode(67200161) 
end
function c67200242.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp)   and c67200242.filter(chkc) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.IsExistingTarget(c67200242.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,c67200242.filter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c67200242.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 or tc:IsFacedown() or not tc:IsRelateToEffect(e) then
		Duel.SendtoGrave(c,REASON_EFFECT)
		return
	end
	if tc then
		Duel.Exile(c,REASON_EFFECT)
		Duel.BreakEffect()
		Duel.Equip(tp,c,tc)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(c67200242.eqlimit)
		e1:SetLabelObject(tc)
		c:RegisterEffect(e1)
	end
end
function c67200242.eqlimit(e,c)
	return c==e:GetLabelObject()
end

--
function c67200242.synfilter(c,syncard,tuner,f)  
	return (c:IsFaceup() or (c:IsLocation(LOCATION_PZONE) and c:IsType(TYPE_MONSTER))) and c:IsCanBeSynchroMaterial(syncard,tuner) and (f==nil or f(c,syncard))  
end  
function c67200242.syncheck(c,g,mg,tp,lv,syncard,minc,maxc)  
	g:AddCard(c)  
	local ct=g:GetCount()  
	local res=c67200242.syngoal(g,tp,lv,syncard,minc,ct)  
		or (ct<maxc and mg:IsExists(c67200242.syncheck,1,g,g,mg,tp,lv,syncard,minc,maxc))  
	g:RemoveCard(c)  
	return res  
end  
function c67200242.syngoal(g,tp,lv,syncard,minc,ct)  
	return ct>=minc  
		and g:CheckWithSumEqual(Card.GetSynchroLevel,lv,ct,ct,syncard)  
		and Duel.GetLocationCountFromEx(tp,tp,g,syncard)>0  
		and g:FilterCount(Card.IsLocation,nil,LOCATION_PZONE)<=1  
end 
function c67200242.syntg(e,syncard,f,min,max)  
	local minc=min+1  
	local maxc=max+1  
	local c=e:GetHandler()  
	local tp=syncard:GetControler()  
	local lv=syncard:GetLevel()  
	if lv<=c:GetLevel() then return false end  
	local g=Group.FromCards(c)  
	local mg=Duel.GetMatchingGroup(c67200242.synfilter,tp,LOCATION_MZONE+LOCATION_PZONE,LOCATION_MZONE,c,syncard,c,f)  
	if not syncard:IsCode(67200161) then return false end
	return mg:IsExists(c67200242.syncheck,1,g,g,mg,tp,lv,syncard,minc,maxc)  
end  
function c67200242.synop(e,tp,eg,ep,ev,re,r,rp,syncard,f,min,max)  
	local minc=min+1  
	local maxc=max+1  
	local c=e:GetHandler()  
	local lv=syncard:GetLevel()  
	local g=Group.FromCards(c)  
	local mg=Duel.GetMatchingGroup(c67200242.synfilter,tp,LOCATION_MZONE+LOCATION_PZONE,LOCATION_MZONE,c,syncard,c,f) 
	if not syncard:IsCode(67200161) then return false end 
	for i=1,maxc do  
		local cg=mg:Filter(c67200242.syncheck,g,g,mg,tp,lv,syncard,minc,maxc)  
		if cg:GetCount()==0 then break end  
		local minct=1  
		if c67200242.syngoal(g,tp,lv,syncard,minc,i) then  
			minct=0  
		end  
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)  
		local sg=cg:Select(tp,minct,1,nil)  
		if sg:GetCount()==0 then break end  
		g:Merge(sg)  
	end  
	if g:IsExists(Card.IsLocation,1,nil,LOCATION_PZONE) then  
		for tc in aux.Next(g) do  
		end  
	end  
	Duel.SetSynchroMaterial(g)  
end
--
