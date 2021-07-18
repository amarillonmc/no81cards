--渊海轻唱·回归浊流
function c79029456.initial_effect(c)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_TO_HAND)
	e1:SetRange(LOCATION_HAND+LOCATION_DECK)
	e1:SetCondition(c79029456.condition)
	e1:SetOperation(c79029456.operation)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCondition(c79029456.fzcon)
	e2:SetOperation(c79029456.fzop)
	c:RegisterEffect(e2)
	--
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetOperation(c79029456.lpop)
	c:RegisterEffect(e3)
end
function c79029456.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,79029456)==0 
end
function c79029456.operation(e,tp,eg,ep,ev,re,r,rp)
	Debug.Message("那么，就请听听这远海的歌吧......")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029456,1))
	local c=e:GetHandler()
	Duel.RegisterFlagEffect(tp,79029456,0,0,0)
	Duel.Hint(HINT_CARD,0,79029456)
	Duel.MoveToField(c,tp,tp,LOCATION_FZONE,POS_FACEUP,true)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_LOSE_KOISHI)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(79029456,0))
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(79029456)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
	e2:SetTargetRange(1,0)
	Duel.RegisterEffect(e2,tp)
end
function c79029456.fzcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(nil,tp,0,LOCATION_ONFIELD+LOCATION_HAND,1,nil) and (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2)
end
function c79029456.fzop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.SetLP(tp,Duel.GetLP(tp)-1000)
	local tc=Duel.SelectMatchingCard(tp,nil,tp,0,LOCATION_ONFIELD+LOCATION_HAND,1,1,nil):GetFirst()
	Duel.Exile(tc,REASON_EFFECT)
	Duel.BreakEffect()
	local tc1=Duel.CreateToken(tp,tc:GetOriginalCode())
	if tc1:IsAbleToHand() then 
	Duel.SendtoHand(tc1,tp,REASON_EFFECT) 
	Duel.ConfirmCards(1-tp,tc1)
	elseif tc1:IsAbleToExtra() then 
	Duel.SendtoDeck(tc1,tp,2,REASON_EFFECT)
	end
	--
	local flag=Duel.GetFlagEffectLabel(tp,09029456) 
	if flag~=nil then 
	Duel.SetFlagEffectLabel(tp,09029456,flag+1)
	else
	Duel.RegisterFlagEffect(tp,09029456,0,0,0,2)
	end
	local flag=Duel.GetFlagEffectLabel(tp,09029456) 
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029456,flag))  
	if flag==2 then 
	Debug.Message("别把我当成灾厄。我不想让谁死去。")   
	elseif flag==3 then  
	Debug.Message("随我走吧，随我回去我们永恒的故乡。")  
	elseif flag==4 then  
	Debug.Message("歌声会沁入你们的心灵。")	
	elseif flag==5 then  
	Debug.Message("空气与陆地......都太干燥。")   
	elseif flag==6 then  
	Debug.Message("放心吧。不会有问题的。")	
	elseif flag==7 then  
	Debug.Message("别害怕，我的同胞们......很快就要到了。") 
	elseif flag==8 then  
	Debug.Message("为什么要逃走呢？这样挣扎只会带给自己更多无谓的恐慌。") 
	elseif flag==9 then  
	Debug.Message("这里迟早也会回归它原来的样子。")	
	elseif flag==10 then  
	Debug.Message("他们会成为我们的血亲。他们不用再受干燥的苦。他们原本的活法太辛苦了。")   
	elseif flag==11 then  
	Debug.Message("这些事情......我见过太多了。已经没人需要这些了")  
	elseif flag==12 then   
	Debug.Message("快走吧，博士......逃走吧，从这里，从我身边......逃走吧。")  
	if Duel.IsPlayerAffectedByEffect(tp,79029456) then
	Duel.IsPlayerAffectedByEffect(tp,79029456):Reset()
	end
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(79029457,0))
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(79029457)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
	e3:SetTargetRange(1,0)
	Duel.RegisterEffect(e3,tp)
	for i=1,10 do
	Duel.HintSelection(Group.FromCards(c))   
	end
	c:SetCardData(CARDDATA_CODE,79029457)
	if Duel.SelectYesNo(1-tp,aux.Stringid(79029457,1)) then 
	Duel.Win(tp,REASON_SKADI)
	else
	if Duel.IsPlayerAffectedByEffect(tp,79029457) then
	Duel.IsPlayerAffectedByEffect(tp,79029457):Reset()
	end
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(79029457,11))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(09029457)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
	e1:SetTargetRange(1,0)
	Duel.RegisterEffect(e1,tp)
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029457,2))	
	for i=1,10 do
	Duel.HintSelection(Group.FromCards(c))   
	end 
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029457,3))	
	for i=1,10 do
	Duel.HintSelection(Group.FromCards(c))   
	end 
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029457,4))	
	for i=1,10 do
	Duel.HintSelection(Group.FromCards(c))   
	end 
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029457,5))	
	for i=1,10 do
	Duel.HintSelection(Group.FromCards(c))   
	end 
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029457,6))	
	for i=1,10 do
	Duel.HintSelection(Group.FromCards(c))   
	end 
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029457,7))	
	for i=1,10 do
	Duel.HintSelection(Group.FromCards(c))   
	end 
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029457,8))	
	for i=1,10 do
	Duel.HintSelection(Group.FromCards(c))   
	end 
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029457,9))	
	for i=1,150 do
	Duel.HintSelection(Group.FromCards(c))   
	end 
	if Duel.IsPlayerAffectedByEffect(tp,09029457) then
	Duel.IsPlayerAffectedByEffect(tp,09029457):Reset()
	end
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(79029457,12))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(19029457)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
	e1:SetTargetRange(1,0)
	Duel.RegisterEffect(e1,tp)
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029457,10))   
	for i=1,300 do
	Duel.HintSelection(Group.FromCards(c))  
	Duel.Win(tp,REASON_SKADI) 
	end 
	end
	end
end
function c79029456.lpop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SetLP(tp,8000)
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029456,13))  
	Debug.Message("不该再有更多生命消逝了。") 
end









